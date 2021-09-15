public with sharing class verifyUser {
    @AuraEnabled(cacheable = true)
    public static string checkUser(Id userId){
        AccountTeamMember lst = [Select UserId from AccountTeamMember where UserId =: userId LIMIT 1];
        if(lst != null){
            return 'success';
        }else {
            return 'fail';
        }
    }
}