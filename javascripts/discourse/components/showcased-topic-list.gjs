import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import TopicList from "discourse/components/topic-list/list";
import { i18n } from "discourse-i18n";

export default class ShowcasedTopicList extends Component {
  @service store;

  @tracked topicList;
  @tracked isLoading = true;

  get category() {
    return this.args.category;
  }

  get href() {
    if (this.category) {
      return this.category.url + "/l/latest?order=votes";
    } else {
      return "#";
    }
  }

  @action
  async getTopics() {
    if (!this.category) {
      this.topicList = [];
      return;
    }

    const filter = {
      filter: "votes",
      params: {
        category: this.category?.id,
      },
    };

    try {
      const topicList = await this.store.findFiltered("topicList", filter);
      this.topicList = topicList.topics
        .filter((topic) => topic.can_vote)
        .slice(0, settings.max_list_length);
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error("Error getting topics:", error);
      this.topicList = [];
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    <div class="topic-list-wrapper">
      <div class="header-wrapper" {{didInsert this.getTopics}}>
        <h2>{{@title}}</h2>
      </div>
      <ConditionalLoadingSpinner @condition={{this.isLoading}}>
        <TopicList
          @topics={{this.topicList}}
          @highlightLastVisited={{true}}
          @showPosters={{true}}
          @sortable={{@changeSort}}
        />
      </ConditionalLoadingSpinner>
      <div class="center-wrapper">
        <a href={{this.href}} class="btn btn-more">
          {{i18n (themePrefix "see_all")}}
        </a>
      </div>
    </div>
  </template>
}
