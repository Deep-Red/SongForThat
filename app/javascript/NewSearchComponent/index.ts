import { Component } from "@angular/core";
import { Http      } from "@angular/http";
import { Router    } from "@angular/router";
import   template    from "./template.html";

import   * as _      from "lodash";

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
      var that = this;

      this.getSongs = _.debounce((term, request) => {
        request.get(
          "/songs.json?keywords=" + term
        ).subscribe(
          function(response) {
            that.songs = response.json().songs;
          }
        );
      }, 762, {'leading': true, 'trailing': true});

      this.getTags = _.debounce((term, request) => {
        request.get(
          "/tags.json?keywords=" + term
        ).subscribe(
          function(response) {
            that.tags = response.json().tags;
          }
        );
      }, 762, {'leading': true, 'trailing': true});

    },
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
    if (self.keywords.length < 2) {
      return;
    }

    self.getSongs(self.keywords, self.http);
    self.getTags(self.keywords, self.http);

  }
});

export { NewSearchComponent };
