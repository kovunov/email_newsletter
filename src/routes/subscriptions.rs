use actix_web::{web::Form, HttpResponse};

#[derive(serde::Deserialize)]
pub struct FormData {
    name: String,
    email: String,
}

pub async fn subscriptions(_form: Form<FormData>) -> HttpResponse {
    HttpResponse::Ok().finish()
}
