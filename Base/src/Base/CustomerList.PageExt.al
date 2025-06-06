namespace CosmoConsult.Operations.Own.Base;

using Microsoft.Sales.Customer;

pageextension 50000 "CCO Customer List" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action(CCOFillCreditLimits)
            {
                ApplicationArea = All;
                Caption = 'Fill Credit Limits';
                Image = AutoReserve;
                ToolTip = 'Fills the credit limits for all customers based on their sales history.';
                trigger OnAction()
                var
                    Customer: Record Customer;
                    FillCreditLimits: Codeunit "CCO Fill Credit Limits";
                begin
                    CurrPage.SetSelectionFilter(Customer);
                    FillCreditLimits.RunForAll(Customer);
                end;
            }
        }
    }
}