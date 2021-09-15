import { LightningElement, wire,api } from 'lwc';
import checkUser from '@salesforce/apex/verifyUser.checkUser';
import strUserId from '@salesforce/user/Id';


export default class Lwcassignment1 extends LightningElement {
    message = "Hello World!!";
   /* @wire(checkUser,{strUserId})
    wiredAccounts({ error, data }) {
        if (data) {
            if(data == "success"){
                console.log("Succefully clicked")
            }
            else{
                
            }
        } else if (error) {
            console.log("Error message is : ",error);
        }
    }*/
    handleQuickAction(){
        checkUser(strUserId).then(result => {
            if(result === 'success'){
                
                console.log("Succefully clicked")
            }
        }).catch(error => {
            console.log("Error"+error);
        })
    }
}