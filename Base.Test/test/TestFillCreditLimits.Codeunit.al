namespace CosmoConsult.Operations.Own.Base.Test;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using CosmoConsult.Operations.Own.Base;

codeunit 70001 "CCO Test Fill Credit Limits"
{
    Subtype = Test;
    Permissions = tabledata "Cust. Ledger Entry" = RI;

    /// <summary>
    /// [SCENARIO] If a customer has a sales history, their credit limit is updated.
    /// [GIVEN] A customer with sales history.
    /// [WHEN] The credit limit update procedure is called.
    /// [THEN] The customer's credit limit is set to a value different than zero.
    /// </summary>
    [Test()]
    procedure IfCustomerHasSalesHistoryThenCreditLimitIsUpdated()
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        FillCreditLimits: Codeunit "CCO Fill Credit Limits";
        Assert: Codeunit Assert;
    begin

        // [GIVEN] A customer with sales history.
        Customer.Init();
        Customer."No." := 'C0001';
        Customer."Credit Limit (LCY)" := 0.00;
        Customer.Insert();

        CustLedgerEntry.Init();
        CustLedgerEntry."Customer No." := Customer."No.";
        CustLedgerEntry."Sales (LCY)" := 1000.00;
        CustLedgerEntry.Insert();

        // [WHEN] The credit limit update procedure is called.
        FillCreditLimits.RunForOne(Customer);

        // [THEN] The customer's credit limit is set to a value different than zero.
        Assert.IsTrue(Customer."Credit Limit (LCY)" > 0.00, 'The credit limit should be updated to a value greater than zero.');
    end;


}