import Component from "@glimmer/component";
import { service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";
import Category from "discourse/models/category";
import ShowcasedTopicList from "../components/showcased-topic-list";

export default class TopicList extends Component {
  @service router;

  get category() {
    return Category.findById(parseInt(settings.select_category, 10));
  }

  get categoryName() {
    return this.category?.name;
  }

  get showTopicLists() {
    return this.category;
  }

  get shouldShow() {
    if (!this.showTopicLists) {
      return false;
    } else {
      if (this.router.currentRouteName === `discovery.${defaultHomepage()}`) {
        return true;
      }
    }
  }

  <template>
    {{#if this.shouldShow}}
      <ShowcasedTopicList
        @category={{this.category}}
        @title={{this.categoryName}}
      />
    {{/if}}
  </template>
}
