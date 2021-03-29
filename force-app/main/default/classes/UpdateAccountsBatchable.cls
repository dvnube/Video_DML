global with sharing class UpdateAccountsBatchable implements Database.Batchable<SObject>, Database.Stateful
{
    private String query;
    global String errorMessageHtml;

    global UpdateAccountsBatchable()
    {
        errorMessageHtml = '';
        query = AccountsSelector.getInstance().buildQuery();
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for (Account acc : scope)
        {
            acc.BillingCountry = acc.ShippingCountry;
        }

        List<Database.SaveResult> srList = Database.update(scope, false);
        
        handleLog(srList, scope);
    }

    global void finish(Database.BatchableContext BC)
    {
        sendLog();
    }

    private void handleLog(List<Database.SaveResult> srList, List<Account> scope)
    {
        for (Integer i = 0; i < scope.size(); i++)
        {
            if (!srList.get(i).isSuccess())
            {
                errorMessageHtml += '====== [' + 'Erro ao atualizar o registro: ' + scope.get(i).Id + '] ====<br/>' ;
                for (Database.Error err: srList.get(i).getErrors())
                {
                    errorMessageHtml += 'Mensagem: ' + err.getMessage() + '<br/>';
                }
            }
        }
    }

    private void sendLog()
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new List<String>{'email@desejado.com'});
        message.setSubject('Log de erros');
        message.setHtmlBody(errorMessageHtml);
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>{message};
        
        Messaging.sendEmail(messages);
    }

}