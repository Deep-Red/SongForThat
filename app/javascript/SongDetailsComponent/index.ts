import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Router         } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";

var SongDetailsComponent = Component({
  selector: "asft-song-details",
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
      this.song           = null;
      this.router         = router;
    }
  ],
  viewDetails: function(element) {
    if (element.name)
      var cont = "tags";
    else if (element.title)
      var cont = "songs";

    this.router.navigate(["/", cont, element.id]);
  },
  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      alert(response);
    }
    var songGetSuccess = function(response) {
      self.song = response.json().song;
      self.tags = response.json().tags;
    }
    var routeSuccess = function(params) {
      self.http.get(
        "/songs/" + params["id"] + ".json"
      ).subscribe(
        songGetSuccess,
        observableFailed
      );
    }
    self.activatedRoute.params.subscribe(routeSuccess,observableFailed);
  },
});
export { SongDetailsComponent };
