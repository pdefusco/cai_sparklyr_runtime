install.packages("dplyr")

library(sparklyr)
library(dplyr)

# Spark configuration
config <- spark_config()
config$spark.kerberos.access.hadoopFileSystems <- "s3a://goes-se-sandbox/"
config$spark.executor.cores = 1
config$spark.executor.memory = "2g"

# Connect to Spark
sc <- spark_connect(config = config)

# -----------------------------
# Create a simple dataframe in R
# -----------------------------
local_df <- data.frame(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Charlie"),
  score = c(85, 90, 95)
)

# Copy it to Spark
spark_df <- copy_to(sc, local_df, "example_table", overwrite = TRUE)

# View the Spark dataframe
spark_df %>% collect()

# Optional: do a simple transformation
spark_df %>%
  filter(score > 85) %>%
  arrange(desc(score)) %>%
  collect()
