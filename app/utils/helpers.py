import random
import string


def generate_otp(length: int = 6) -> str:
    return "".join(random.choices(string.digits, k=length))


def generate_filename(prompt: str) -> str:
    clean = "".join(c if c.isalnum() or c in (" ", "-", "_") else "" for c in prompt)
    clean = clean.strip().replace(" ", "_").lower()
    return f"{clean[:50]}.pine"
