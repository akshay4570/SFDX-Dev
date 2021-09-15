import { LightningElement, track, wire } from 'lwc';
import getCandidatesList from '@salesforce/apex/candidateController.getCandidatesList';

export default class LwcPractice extends LightningElement {

    @track searchKey;
    @track candidates;
    @track error;
    @wire(getCandidatesList,{
        name : '$searchKey'
    })
    wiredCandidates({error,data}){
        if(data){
            /* eslint-disable no-console */
            console.log(data);
            this.candidates = data;
        }
        if(error){
            this.error = error;
        }
    }

    handleChange(event){
        event.preventDefault();
        this.searchKey = event.target.value;
    }

}