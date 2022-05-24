use reqwest::Response;
use yew::prelude::*;
use serde_json::Value;

#[derive(Clone, Debug, PartialEq)]
struct Joke {
    value: String,
}

async fn fetch_joke() -> Joke {
    const URL: &str = "https://api.yomomma.info";

    let response: Response = reqwest::get(URL).await.unwrap();

    let text: String = response.text().await.unwrap();

    let serialized_response: Value = serde_json::from_str(&text).unwrap();

    let joke: &str = serialized_response["joke"].as_str().unwrap();

    return Joke {
        value: String::from(joke),
    };
}

#[function_component(App)]
fn app() -> Html {
    html! {
        <div>
            <h1>{"Hello, world!"}</h1>
        </div>
    }
}

fn main() {
    yew::start_app::<App>();
}
