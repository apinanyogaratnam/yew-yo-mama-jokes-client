use reqwest::Response;
use yew::prelude::*;
use serde_json::Value;

#[derive(Clone, Debug, PartialEq)]
struct Joke {
    value: String,
}

async fn fetch_joke() -> Joke {
    const URL: &str = "http://127.0.0.1:5000/jokes";

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
    let joke_state = use_state_eq::<Option<Joke>, _>(|| None);
    let joke_state_outer = joke_state.clone();

    wasm_bindgen_futures::spawn_local(async move {
        let joke = fetch_joke().await;
        web_sys::console::log_1(&format!("{:?}", joke).into());
        let joke_state = joke_state.clone();
        joke_state.set(Some(joke));
    });

    match (*joke_state_outer).clone() {
        Some(joke) => html! {
            <div>
                <h1>{ "Yo mama Joke" }</h1>
                <p>{ joke.value }</p>
            </div>
        },
        None => html! {
            <div>
                <h1>{ "Yo mama Joke" }</h1>
                <p>{ "Loading..." }</p>
            </div>
        },
    }
}

fn main() {
    yew::start_app::<App>();
}
