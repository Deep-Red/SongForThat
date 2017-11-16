import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Router         } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";
import   * as _           from "lodash";

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

      var that = this;
      this.newTags        = [];

      this.getTags = _.debounce((term, request) => {
        request.get(
          "/tags.json?keywords=" + term
        ).subscribe(
          function(response) {
            that.newTags = response.json().tags;
          }
        );
      }, 762, {'leading': true, 'trailing': true});

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
    if (self.keywords.length < 2) {
      return;
    }

    self.getTags(self.keywords, self.http);

  },
  addTag: function(name) {
    var self = this;
    self.http.post(
      "/tags.json?",
      {tag: {name: name}}
    ).subscribe(
      function(response) {
      self.newTags.unshift(response.json().tag);
      }
    );
  },
  addTagging: function(tag, song) {
    var self = this;
    self.tag = tag;
    self.song = song.id;
    self.category = "content";
    self.http.post(
      "/taggings.json?",
      {tagging: {tag: self.tag.id,
      song: self.song,
      category: self.category}}
    ).subscribe(
      function(response) {
        console.log(self.tag);
        self.tags.push(self.tag);
      }
    );
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
