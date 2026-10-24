from pathlib import Path

ROOT = Path(__file__).parents[2]
INCLUDE = ROOT / "MQL5" / "Include" / "FER3ON"


def read(name: str) -> str:
    return (INCLUDE / name).read_text(encoding="utf-8")


def test_contract_headers_exist_and_are_guarded():
    for name in (
        "BuildInfo.mqh",
        "Domain.mqh",
        "SignalContract.mqh",
        "DecisionContract.mqh",
        "RiskContract.mqh",
        "TradeJournal.mqh",
    ):
        text = read(name)
        assert "#property strict" in text
        assert "#ifndef FER3ON_" in text
        assert "#endif" in text


def test_risk_limits_are_centralized():
    text = read("RiskContract.mqh")
    assert "FER3ON_START_LOT              0.01" in text
    assert "FER3ON_PHASE1_MAX_LOT         0.02" in text
    assert "FER3ON_DAILY_LOSS_PERCENT     5.0" in text
    assert "FER3ON_DAILY_LOSS_CASH        50.0" in text
    assert "FER3ON_BREAK_EVEN_R           1.0" in text


def test_journal_rejects_incomplete_records():
    text = read("TradeJournal.mqh")
    assert "IsSignalComplete" in text
    assert "IsPlanComplete" in text
    assert "if(!Ready() || !IsSignalComplete(signal)) return false;" in text
    assert "signal.state==FER3ON_STATE_ENTER && !IsPlanComplete(plan)" in text
    assert '"DECISION"' in text
    assert '"EXECUTION"' in text


def test_journal_has_a_single_explainable_schema():
    text = read("TradeJournal.mqh")
    for field in (
        "build_id", "signal_id", "strategy_id", "strategy_version",
        "reason_code", "detail", "risk_cash", "lot_final",
    ):
        assert field in text
