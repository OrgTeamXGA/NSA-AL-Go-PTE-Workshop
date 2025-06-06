
namespace CosmoConsult.Operations.Own.Base;

using Microsoft.Sales.Customer;

/// <summary>
/// Codeunit to fill credit limits for customers based on their sales history.
/// </summary>
codeunit 50000 "CCO Fill Credit Limits"
{
    Access = Internal;
    SingleInstance = true;

    /// <summary>
    /// Runs the credit limit update for all customers.
    /// </summary>
    /// <param name="Customer"></param>
    procedure RunForAll(var Customer: Record Customer)
    begin
        if Customer.FindSet(true) then
            repeat
                RunForOne(Customer);
            until Customer.Next() = 0;
    end;

    /// <summary>
    /// Updates the credit limit for a single customer based on their sales history.
    /// </summary>
    /// <param name="Customer"></param>
    procedure RunForOne(var Customer: Record Customer)
    begin
        Customer.CalcFields("Sales (LCY)");
        Customer.Validate("Credit Limit (LCY)", Round(Customer."Sales (LCY)" * 1.2, 0.01, '='));
        Customer.Modify(true);
    end;
}