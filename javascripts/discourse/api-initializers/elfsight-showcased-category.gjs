import { apiInitializer } from "discourse/lib/api";
import TopicList from "../components/topic-list";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", TopicList);
});
