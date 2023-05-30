@isTest
public class Facturas_vencidas_test {
    
    @isTest
    static void test_facturas_vencidas_trigger() {
        Account a = new Account(Name='Test Account', Numero_de_cuenta__c='456C');
        insert a;
        
        Contact c = new Contact(Lastname='Test Person', Numero_de_cuenta__c='123AB');
        insert c;
        
        Facturas_vencidas__c fv = new Facturas_vencidas__c(Cliente__c='123AB', Responsable_de_Cobranza__c='456C');
        insert fv;
        
        fv = [SELECT id, Account__c, Contact__c FROM Facturas_vencidas__c WHERE Id=:fv.Id];
        
        System.assertequals(a.Id, fv.Account__c);
        System.assertequals(c.Id, fv.Contact__c);
        
    }
}