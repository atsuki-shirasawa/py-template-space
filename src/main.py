"""sample"""
import click


def calc_sale_amount(price: int, qty: int, tax: float = 0.1) -> int:
    """Calc sales amount

    Args:
        price (int): price
        qty (int): quanty
        tax (float, optional): tax. Defaults to 0.1.

    Returns:
        int: amount
    """
    return round(((price * qty) * (1 + tax)))


@click.command()
@click.option("--price", type=int, required=True, help="price of item")
@click.option("--qty", type=int, required=True, help="quantity of sales item")
@click.option("--tax", type=float, required=False, default=0.1, help="tax")
def main(price: int, qty: int, tax: float = 0.1) -> None:
    """Main function

    Args:
        price (int): price
        qty (int): quantity
        tax (float, optional): tax rate. Defaults to 0.1.
    """
    amount = calc_sale_amount(price, qty, tax)
    click.echo(f"sales amount: {amount}!")


if __name__ == "__main__":
    main()
