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
        CustLedgerEntry."Entry No." := CustLedgerEntry.GetLastEntryNo() + 1;
        CustLedgerEntry."Customer No." := Customer."No.";
        CustLedgerEntry."Sales (LCY)" := 1000.00;
        CustLedgerEntry.Insert();

        // [WHEN] The credit limit update procedure is called.
        FillCreditLimits.RunForOne(Customer);

        // [THEN] The customer's credit limit is set to a value different than zero.
        Assert.IsTrue(Customer."Credit Limit (LCY)" > 0.00, 'The credit limit should be updated to a value greater than zero.');
    end;

    /// <summary>
    /// [SCENARIO] If a customer has no sales history, their credit limit remains unchanged.
    /// [GIVEN] A customer with no sales history.
    /// [WHEN] The credit limit update procedure is called.
    /// [THEN] The customer's credit limit remains unchanged.
    /// </summary>
    [Test()]
    procedure IfCustomerHasNoSalesHistoryThenCreditLimitRemainsUnchanged()
    var
        Customer: Record Customer;
        FillCreditLimits: Codeunit "CCO Fill Credit Limits";
        Assert: Codeunit Assert;
    begin
        // [GIVEN] A customer with no sales history.
        Customer.Init();
        Customer."No." := 'C0002';
        Customer."Credit Limit (LCY)" := 500.00;
        Customer.Insert();

        // [WHEN] The credit limit update procedure is called.
        FillCreditLimits.RunForOne(Customer);

        // [THEN] The customer's credit limit remains unchanged.
        Assert.AreEqual(500.00, Customer."Credit Limit (LCY)", 'The credit limit should remain unchanged for customers with no sales history.');
    end;

    /// <summary>
    /// [SCENARIO] If a customer has a negative sales history, their credit limit is set to zero.
    /// [GIVEN] A customer with negative sales history.
    /// [WHEN] The credit limit update procedure is called.
    /// [THEN] The customer's credit limit is set to zero.
    /// </summary>
    [Test()]
    procedure IfCustomerHasNegativeSalesHistoryThenCreditLimitIsZero()
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        FillCreditLimits: Codeunit "CCO Fill Credit Limits";
        Assert: Codeunit Assert;
    begin
        // [GIVEN] A customer with negative sales history.
        Customer.Init();
        Customer."No." := 'C0003';
        Customer."Credit Limit (LCY)" := 1000.00;
        Customer.Insert();

        CustLedgerEntry.Init();
        CustLedgerEntry."Entry No." := CustLedgerEntry.GetLastEntryNo() + 1;
        CustLedgerEntry."Customer No." := Customer."No.";
        CustLedgerEntry."Sales (LCY)" := -500.00;
        CustLedgerEntry.Insert();

        // [WHEN] The credit limit update procedure is called.
        FillCreditLimits.RunForOne(Customer);

        // [THEN] The customer's credit limit is set to zero.
        Assert.AreEqual(0.00, Customer."Credit Limit (LCY)", 'The credit limit should be set to zero for customers with negative sales history.');
    end;


}