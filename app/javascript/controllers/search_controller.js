
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    service: String,
    url: String
  }
  static targets = ["result"]

  connect() {
    console.log("Search controller conected. Service: ", this.serviceValue)
    let result = false 
    fetch("/check", {
      method: 'POST', // or 'PUT'
      body: JSON.stringify({"url": this.urlValue, "service": this.serviceValue}), 
      headers:{
        'Content-Type': 'application/json'
      }
    }).then(res => res.json())
    .catch(error => console.error('Error:', error))
    .then(response =>{ 
      console.log(response);
      if(response.success){
        this.resultTarget.innerHTML = "<div class='flex justify-end'><img src='checked.png' class='max-h-8' ></div>"
      }else{
        this.resultTarget.innerHTML = "<div class='flex justify-end'><img src='unchecked.png' class='max-h-8' ></div>"
      } 
    })
  }
}
