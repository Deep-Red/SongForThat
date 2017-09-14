import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Router         } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";

var TagDetailsComponent = Component({
  selector: "asft-tag-details",
  template: template
}).Class({
  constructor: [
    ActivatedRoute,
    Http,
    Router,
    function(activatedRoute, http, router) {
      this.activatedRoute = activatedRoute;
      this.http           = http;
      this.id             = null;
      this.tag            = null;
      this.router         = router;
    }
  ],
  viewDetails: function(element) {
    if (element.name)
      var cont = "tags";
    else if (element.title)
      var cont = "songs";

    this.router.navigate(["/", cont, element.id])
  },
  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      alert(response);
    }
    var tagGetSuccess = function(response) {
      self.tag = response.json().tag;
      self.songs = response.json().songs;
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
