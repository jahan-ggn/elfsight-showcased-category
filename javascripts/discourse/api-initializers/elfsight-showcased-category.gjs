import routeAction from "discourse/helpers/route-action";
import { apiInitializer } from "discourse/lib/api";
import { defaultHomepage } from "discourse/lib/utilities";
import VoteBox from "discourse/plugins/discourse-topic-voting/discourse/components/vote-box";
import TopicList from "../components/topic-list";

const VotesHeaderCell = <template>
  <th>Votes</th>
</template>;

const VotesItemCell = <template>
  {{#if @topic.can_vote}}
    <td class="vote-before-topic">
      <VoteBox @topic={{@topic}} @showLogin={{routeAction "showLogin"}} />
    </td>
  {{else}}
    <td> </td>
  {{/if}}
</template>;

export default apiInitializer((api) => {
  const discoveryService = api.container.lookup("service:discovery");
  api.renderInOutlet("above-main-container", TopicList);
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (
      discoveryService.router.currentRouteName ===
      `discovery.${defaultHomepage()}`
    ) {
      columns.add(
        "votes",
        {
          header: VotesHeaderCell,
          item: VotesItemCell,
        },
        { before: "topic" }
      );
    }
  });
});
