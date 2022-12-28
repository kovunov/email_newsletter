use actix_web::{dev::Server, web, App, HttpResponse, HttpServer, Responder};

async fn healthcheck() -> impl Responder {
    HttpResponse::Ok()
}

pub fn run() -> Result<Server, std::io::Error> {
    let server = HttpServer::new(|| App::new().route("/health", web::get().to(healthcheck)))
        .bind("127.0.0.1:8080")?
        .run();
    Ok(server)
}
