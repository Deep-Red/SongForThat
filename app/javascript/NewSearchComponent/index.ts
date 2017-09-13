import { Component } from "@angular/core";
import { Http      } from "@angular/http";
import { Router    } from "@angular/router";
import   template    from "./template.html";

var NewSearchComponent = Component({

  selector: "asft-new-search",
  template: template
}).Class({
  constructor: [
    Http,
    Router,
    function(http, router) {
      this.songs = null;
      this.tags = null;
      this.http      = http;
      this.keywords  = "";
      this.router = router;
    }
  ],
  viewDetails: function(element) {
    if (element.name)
      var cont = "tags";
    else if (element.title)
      var cont = "songs";

    this.router.navigate(["/", cont, element.id]);
  },
  search: function($event) {
    var self = this;
    self.keywords = $event;
    if (self.keywords.length < 3) {
      return;
    }
    self.http.get(
      "/songs.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.songs = response.json().songs;
      }
    );
    self.http.get(
      "/tags.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.tags = response.json().tags;
      }
    );
  }
});

export { NewSearchComponent };
