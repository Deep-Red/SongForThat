import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";

var TagDetailsComponent = Component({
  selector: "asft-tag-details",
  template: template
}).Class({
  constructor: [
    ActivatedRoute,
    Http,
    function(activatedRoute,http) {
      this.activatedRoute = activatedRoute;
      this.http           = http;
      this.id             = null;
      this.tag           = null;
    }
  ],
  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      alert(response);
    }
    var tagGetSuccess = function(response) {
      self.tag = response.json().tag;
      self.tags = response.json().tags;
    }
    var routeSuccess = function(params) {
      self.http.get(
        "/tags/" + params["id"] + ".json"
      ).subscribe(
        tagGetSuccess,
        observableFailed
      );
    }
    self.activatedRoute.params.subscribe(routeSuccess,observableFailed);
  },
});
export { TagDetailsComponent };
