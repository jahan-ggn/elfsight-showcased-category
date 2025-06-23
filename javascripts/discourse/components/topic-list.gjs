import Component from "@glimmer/component";
import { service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";
import Category from "discourse/models/category";
import ShowcasedTopicList from "../components/showcased-topic-list";

export default class TopicList extends Component {
  @service router;

  get categories() {
    if (!settings.select_category) {
      return [];
    }

    return settings.select_category
      .split("|")
      .map((id) => parseInt(id, 10))
      .map((id) => Category.findById(id))
      .filter(Boolean);
  }

  get shouldShow() {
    return (
      this.categories.length > 0 &&
      this.router.currentRouteName === `discovery.${defaultHomepage()}`
    );
  }

  <template>
    {{#if this.shouldShow}}
      {{#each this.categories as |category|}}
        <ShowcasedTopicList @category={{category}} @title={{category.name}} />
      {{/each}}
    {{/if}}
  </template>
}
