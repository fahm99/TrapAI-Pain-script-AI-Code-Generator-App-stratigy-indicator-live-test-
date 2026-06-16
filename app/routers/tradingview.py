from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional

from app.database import get_db
from app.models.models import User
from app.schemas.schemas import ChartConfig, PineCodeInject
from app.middleware.auth import get_current_user
from app.services.tradingview_service import TradingViewService

router = APIRouter()
tv_service = TradingViewService()


@router.get("/symbols")
async def search_symbols(query: str = ""):
    symbols = await tv_service.search_symbols(query)
    return {"symbols": symbols}


@router.get("/symbol/{symbol}")
async def get_symbol_info(symbol: str):
    info = await tv_service.get_symbol_info(symbol)
    return info


@router.get("/timeframes")
async def get_timeframes():
    return {
        "timeframes": [
            {"value": "1", "label": "1m"},
            {"value": "5", "label": "5m"},
            {"value": "15", "label": "15m"},
            {"value": "60", "label": "1h"},
            {"value": "240", "label": "4h"},
            {"value": "D", "label": "1D"},
            {"value": "W", "label": "1W"},
        ]
    }


@router.post("/widget-config")
async def get_widget_config(
    config: ChartConfig,
    current_user: User = Depends(get_current_user),
):
    widget_config = tv_service.generate_widget_config(
        symbol=config.symbol,
        timeframe=config.timeframe,
        theme=config.theme,
    )
    return widget_config


@router.post("/inject-script")
async def inject_pine_script(
    data: PineCodeInject,
    current_user: User = Depends(get_current_user),
):
    result = tv_service.inject_script(
        script=data.script,
        config=data.chart_config,
    )
    return result
