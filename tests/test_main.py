"""test_main.py"""
from src.main import calc_sale_amount


def test_calc_sale_amount() -> None:
    """Test function for calc_sale_amount()"""
    assert calc_sale_amount(price=100, qty=10) == 1100
    assert calc_sale_amount(price=100, qty=5, tax=0.05) == 525
