public without sharing class AccountsSelector extends Selector
{
    private static AccountsSelector instance = null;

    public static AccountsSelector getInstance()
    {
        if (instance == null) 
        {
            instance = new AccountsSelector();
        }

        return instance;
    }

    public AccountsSelector()
    {
        sObjType = Account.sObjectType;
        fieldset = SObjectType.Account.FieldSets.Selector;
    }
}