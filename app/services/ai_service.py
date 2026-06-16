import openai
from app.config import settings
from typing import Dict, Optional


class AIService:
    def __init__(self):
        self.client = openai.AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        self.model = settings.OPENAI_MODEL

    async def generate_pine_script(
        self,
        prompt: str,
        mode: str = "indicator",
        version: str = "v6",
        image_url: Optional[str] = None,
    ) -> Dict[str, str]:
        system_prompt = f"""You are an expert Pine Script developer for TradingView.
Generate Pine Script {version} code based on the user's description.
Mode: {mode}

Rules:
1. Always use Pine Script {version} syntax
2. Include proper comments explaining the logic
3. Use professional variable names
4. Include inputs for customization
5. Add proper alerts if applicable
6. Format the code cleanly with proper indentation

Return your response in this exact format:
CODE:
[pine script code here]

EXPLANATION:
[brief explanation of what the code does]"""

        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt},
        ]

        if image_url:
            messages.append({
                "role": "user",
                "content": [
                    {"type": "text", "text": "Analyze this chart image and generate Pine Script code for it."},
                    {"type": "image_url", "image_url": {"url": image_url}},
                ],
            })

        try:
            response = await self.client.chat.completions.create(
                model=self.model,
                messages=messages,
                temperature=0.7,
                max_tokens=4000,
            )

            content = response.choices[0].message.content

            code = ""
            explanation = ""

            if "CODE:" in content and "EXPLANATION:" in content:
                parts = content.split("EXPLANATION:")
                code = parts[0].replace("CODE:", "").strip()
                explanation = parts[1].strip()
            else:
                code = content
                explanation = "Generated Pine Script code based on your request."

            return {
                "code": code,
                "explanation": explanation,
                "tokens_used": response.usage.total_tokens,
            }

        except Exception as e:
            return {
                "code": self._get_fallback_code(mode, version),
                "explanation": f"Generated a template based on your request. Error: {str(e)}",
                "tokens_used": 0,
            }

    async def explain_code(self, code: str) -> str:
        try:
            response = await self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {
                        "role": "system",
                        "content": "You are an expert Pine Script developer. Explain the following code in detail, line by line if necessary.",
                    },
                    {"role": "user", "content": code},
                ],
                temperature=0.5,
                max_tokens=2000,
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"Unable to explain code: {str(e)}"

    async def optimize_code(self, code: str, instructions: str) -> str:
        try:
            response = await self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {
                        "role": "system",
                        "content": "You are an expert Pine Script developer. Optimize the following code based on the instructions.",
                    },
                    {"role": "user", "content": f"Code:\n{code}\n\nInstructions:\n{instructions}"},
                ],
                temperature=0.5,
                max_tokens=4000,
            )
            return response.choices[0].message.content
        except Exception as e:
            return code

    def _get_fallback_code(self, mode: str, version: str) -> str:
        if mode == "strategy":
            return f'''//@version={version.replace("v", "")}
strategy("AI Strategy", overlay=true, margin_long=100, margin_short=100)

// ─── INPUTS ───
fastLength = input.int(10, "Fast Length")
slowLength = input.int(20, "Slow Length")
rsiLength = input.int(14, "RSI Length")

// ─── CALCULATIONS ───
fastMA = ta.sma(close, fastLength)
slowMA = ta.sma(close, slowLength)
rsi = ta.rsi(close, rsiLength)

// ─── SIGNALS ───
longCondition = ta.crossover(fastMA, slowMA) and rsi < 70
shortCondition = ta.crossunder(fastMA, slowMA) and rsi > 30

// ─── EXECUTION ───
if longCondition
    strategy.entry("Long", strategy.long)

if shortCondition
    strategy.entry("Short", strategy.short)

// ─── PLOTS ───
plot(fastMA, "Fast MA", color=color.green)
plot(slowMA, "Slow MA", color=color.red)
plotshape(longCondition, "Buy", shape.triangleup, location.belowbar, color.green)
plotshape(shortCondition, "Sell", shape.triangledown, location.abovebar, color.red)
'''
        else:
            return f'''//@version={version.replace("v", "")}
indicator("AI Indicator", overlay=true)

// ─── INPUTS ───
length = input.int(20, "MA Length")
rsiLength = input.int(14, "RSI Length")
signalLength = input.int(9, "Signal Length")

// ─── CALCULATIONS ───
ma = ta.sma(close, length)
rsi = ta.rsi(close, rsiLength)

// ─── SIGNALS ───
buySignal = ta.crossover(close, ma) and rsi < 70
sellSignal = ta.crossunder(close, ma) and rsi > 30

// ─── PLOTS ───
plot(ma, "MA", color=rsi > 70 ? color.red : rsi < 30 ? color.green : color.gray, linewidth=2)
plotshape(buySignal, "Buy", shape.labelup, location.belowbar, color.green, size=size.small)
plotshape(sellSignal, "Sell", shape.labeldown, location.abovebar, color.red, size=size.small)

// ─── ALERTS ───
alertcondition(buySignal, "Buy Signal", "Buy signal detected")
alertcondition(sellSignal, "Sell Signal", "Sell signal detected")
'''
