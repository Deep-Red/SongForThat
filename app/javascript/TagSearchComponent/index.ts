import { Component } from "@angular/core";
import { Http      } from "@angular/http";
import   template    from "./template.html";

var TagSearchComponent = Component({

  selector: "asft-tag-search",
  template: template
}).Class({
  constructor: [
    Http,
    function(http) {
      this.tags = null;
      this.http      = http;
      this.keywords  = "";
    }
  ],
  search: function($event) {
    var self = this;
    self.keywords = $event;
    if (self.keywords.length < 3) {
      return;
    }
    self.http.get(
      "/tags.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.tags = response.json().tags;
      },
      function(response) {
        window.alert(response);
      }
    );
  }
});

export { TagSearchComponent };
