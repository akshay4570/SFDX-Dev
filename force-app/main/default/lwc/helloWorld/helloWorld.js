import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    greeting = 'World XYZ';
    changeHandler(event) {
        this.greeting = event.target.value;
  }
}