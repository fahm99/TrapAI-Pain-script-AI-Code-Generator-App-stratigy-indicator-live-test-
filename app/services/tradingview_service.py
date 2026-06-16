from typing import Dict, List, Optional
from app.config import settings


class TradingViewService:
    def __init__(self):
        self.widget_id = settings.TRADINGVIEW_WIDGET_ID

    async def search_symbols(self, query: str) -> List[Dict]:
        popular_symbols = [
            {"symbol": "BTCUSD", "name": "Bitcoin", "exchange": "BINANCE", "type": "crypto"},
            {"symbol": "ETHUSD", "name": "Ethereum", "exchange": "BINANCE", "type": "crypto"},
            {"symbol": "SOLUSD", "name": "Solana", "exchange": "BINANCE", "type": "crypto"},
            {"symbol": "AAPL", "name": "Apple Inc.", "exchange": "NASDAQ", "type": "stock"},
            {"symbol": "GOOGL", "name": "Alphabet Inc.", "exchange": "NASDAQ", "type": "stock"},
            {"symbol": "MSFT", "name": "Microsoft", "exchange": "NASDAQ", "type": "stock"},
            {"symbol": "EURUSD", "name": "EUR/USD", "exchange": "FX", "type": "forex"},
            {"symbol": "GBPUSD", "name": "GBP/USD", "exchange": "FX", "type": "forex"},
            {"symbol": "USDJPY", "name": "USD/JPY", "exchange": "FX", "type": "forex"},
            {"symbol": "GOLD", "name": "Gold", "exchange": "COMEX", "type": "commodity"},
        ]

        if query:
            query_lower = query.lower()
            return [s for s in popular_symbols if query_lower in s["symbol"].lower() or query_lower in s["name"].lower()]

        return popular_symbols

    async def get_symbol_info(self, symbol: str) -> Dict:
        return {
            "symbol": symbol,
            "name": symbol,
            "description": f"{symbol} price chart",
            "type": "unknown",
            "exchange": "unknown",
        }

    def generate_widget_config(
        self,
        symbol: str = "BTCUSD",
        timeframe: str = "15",
        theme: str = "dark",
    ) -> Dict:
        return {
            "autosize": True,
            "symbol": f"BINANCE:{symbol}",
            "interval": timeframe,
            "timezone": "Etc/UTC",
            "theme": theme,
            "style": "1",
            "locale": "en",
            "toolbar_bg": "#1e222d",
            "enable_publishing": False,
            "allow_symbol_change": True,
            "studies": [
                "RSI@tv-basicstudies",
                "MASimple@tv-basicstudies",
                "MACD@tv-basicstudies",
            ],
            "container_id": "tradingview_chart",
            "datafeed_url": f"https://s.tradingview.com/widgetembed/?symbol={symbol}",
        }

    def inject_script(
        self,
        script: str,
        config: Optional[Dict] = None,
    ) -> Dict:
        return {
            "success": True,
            "script": script,
            "message": "Script ready for TradingView injection",
            "instructions": [
                "1. Open TradingView",
                "2. Go to Pine Editor",
                "3. Paste the generated code",
                "4. Click 'Add to Chart'",
            ],
        }

    def get_widget_html(
        self,
        symbol: str = "BTCUSD",
        script: Optional[str] = None,
    ) -> str:
        return f"""
        <div class="tradingview-widget-container">
            <div id="tradingview_chart"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
            <script type="text/javascript">
                new TradingView.widget({{
                    "autosize": true,
                    "symbol": "BINANCE:{symbol}",
                    "interval": "15",
                    "timezone": "Etc/UTC",
                    "theme": "dark",
                    "style": "1",
                    "locale": "en",
                    "toolbar_bg": "#1e222d",
                    "enable_publishing": false,
                    "allow_symbol_change": true,
                    "container_id": "tradingview_chart"
                }});
            </script>
        </div>
        """
