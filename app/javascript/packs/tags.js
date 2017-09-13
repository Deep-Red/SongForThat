import "hello_angular/polyfills";
import { Component, NgModule    } from "@angular/core";
import { BrowserModule          } from "@angular/platform-browser";
import { FormsModule            } from "@angular/forms";
import { platformBrowserDynamic } from "@angular/platform-browser-dynamic";
import { Http,HttpModule        } from "@angular/http";

var TagSearchComponent = Component({
  selector: "asft-tag-search",
  template: '\
  <header>\
  <h1 class="h2">Tag Search</h1>\
  </header>\
  <section class="search-form">\
    <form>\
      <div class="input-group input-group-lg">\
        <label for="keywords" class="sr-only">Keywords</label>\
        <input type="text" id="keywords" name="keywords" \
          placeholder="Tag name" class="form-control input-lg" bindon-ngModel="keywords"\
          on-ngModelChange="search($event)">\
        <span class="input-group-btn">\
          <input type="submit" value="Find Tags" class="btn btn-primary btn-lg" on-click="search()">\
        </span>\
      </div>\
    </form>\
  </section>\
  <section class="search-results">\
    <header>\
      <h1 class="h3">Results</h1>\
    </header>\
    <ol class="list-group">\
        <li *ngFor="let tag of tags" class="list-group-item">\
          <h2> {{ tag.name}} </h2>\
        </li>\
    </ol>\
  </section>\
  '
}).Class({
  constructor: [
    Http,
    function(http) {
      this.tags = null;
      this.http = http;
      this.keywords = "";
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
      }
    );
  }
});

var TagAppModule = NgModule({
  imports:      [ BrowserModule, FormsModule, HttpModule ],
  declarations: [ TagSearchComponent ],
  bootstrap:    [ TagSearchComponent ]
})
.Class({
  constructor: function() {}
});

platformBrowserDynamic().bootstrapModule(TagAppModule);
