use sqlx::{
    migrate::MigrateDatabase,
    query_file,
    sqlite::{self, SqliteQueryResult},
    Connection, Error, Executor, Pool, Sqlite, SqliteConnection, SqlitePool,
};

const DB_URL: &str = "sqlite://db.sql3";
pub struct DB {
    pub conn: Pool<Sqlite>,
}

impl DB {
    pub async fn new() -> Result<Self, Error> {
        if !Sqlite::database_exists(DB_URL).await? {
            Sqlite::create_database(DB_URL).await?
        }

        SqlitePool::connect(DB_URL).await.map(|conn| Self { conn })
    }

    pub async fn init(&mut self) -> Result<SqliteQueryResult, Error> {
        let db_init_sql = include_str!("db_init.sql");
        self.conn.execute(db_init_sql).await
    }
}
