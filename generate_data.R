# Set seed for reproducibility
set.seed(1599)

# Desired correlations
cor_12 <- 0.8
cor_13 <- -0.4
cor_23 <- 0  # No constraint on the correlation between variables 2 and 3

# Build the covariance matrix
cov_matrix <- matrix(c(1, cor_12, cor_13,
                       cor_12, 1, cor_23,
                       cor_13, cor_23, 1), nrow = 3)

# Check if the covariance matrix is positive definite
if (!all(eigen(cov_matrix)$values > 0)) {
  stop("Covariance matrix is not positive definite")
}

# Generate random Gaussian variables
n <- 600  # Number of samples
raw_data <- matrix(rnorm(n * 3), ncol = 3)

# Apply Cholesky decomposition to introduce correlations
L <- chol(cov_matrix)
correlated_data <- raw_data %*% L

# Convert to a data frame for analysis
data <- as.data.frame(correlated_data)
names(data) <- c("Variable1", "Variable2", "Variable3")

# Transform Variable1
data$Variable1 <- data$Variable1 - mean(data$Variable1) + 2
data$Variable1 <- ifelse(data$Variable1 < 0, 0.01, data$Variable1)  # Remove negative values

# Transform Variable2
data$Variable2 <- (data$Variable2 - mean(data$Variable2)) / sd(data$Variable2) * 10000 + 60000
data$Variable2 <- ifelse(data$Variable2 < 0, 0.01, data$Variable2)  # Remove negative values
data$Variable2 <- pmin(data$Variable2, 100000)  # Cap at 100,000

# Transform Variable3
data$Variable3 <- (data$Variable3 - min(data$Variable3)) / (max(data$Variable3) - min(data$Variable3))  # Scale to [0, 1]
data$Variable3 <- data$Variable3 * (0.35 - 0.02) + 0.02  # Scale to [0.02, 0.35]
data$Variable3 <- data$Variable3 - mean(data$Variable3) + 0.1  # Adjust mean to 0.1
data$Variable3 <- ifelse(data$Variable3 < 0, 0.01, data$Variable3) 

# Check the resulting means and correlations
means <- colMeans(data)
correlations <- cor(data)

list(means = means, correlations = correlations)

# repeated measurements


# Generate variables
in1 <- rnorm(n, mean = 40, sd = 7)
in2 <- rnorm(n, mean = 30, sd = 9)
in3 <- rnorm(n, mean = 25, sd = 10)

# Ensure all values are positive by replacing negatives with a small positive value
in1[in1 < 0] <- 0.01
in2[in2 < 0] <- 0.01
in3[in3 < 0] <- 0.01

# Combine into a data frame
rep <- data.frame(in1 = in1, in2 = in2, in3 = in3)


# ANOVA II


# Number of samples per group
n_per_group <- 100
species <- c("Helianthus", "Helianthus", "Triticum", "Triticum", "Arabidopsis", "Arabidopsis")
treat <- c("cold", "warm", 'cold', "warm", "cold", "warm")

# Define means for each group
means <- c(4, 3.5, 7.8, 5.0, 8.0, 9.5)

# Define standard deviation (same for all groups to ensure similar variance)
sd_leaf <- 2

# Generate the data
species <- rep(species, each = n_per_group)  # Create the group variable
treat <- rep(treat, each = n_per_group)  # Create the group variable
Nleaf <- unlist(lapply(means, function(mu) rnorm(n_per_group, mean = mu, sd = sd_leaf)))  # Generate leaf values

# Ensure 'leaf' is positive and convert to integers
Nleaf <- ifelse(Nleaf < 0, 1, Nleaf)  # Replace negative values with 1
Nleaf <- round(Nleaf)  # Convert to integer

# Create a data frame
an <- data.frame(species = species, treat = treat, Nleaf = Nleaf)

# Check summary statistics
aggregate(leaf ~ group, data = an, summary)




## mine

data %>% ggplot(aes(y = Variable1, x = Variable2)) +
  geom_point() +
  geom_smooth()


data %>% ggplot(aes(y = Variable1, x = Variable3)) +
  geom_point() +
  geom_smooth()


model <- lm(data = data, Variable1 ~ Variable2 + Variable3)

summary(model)

check_normality(model)

check_heteroscedasticity(model)

check_autocorrelation(model)

an %>% ggplot(aes(y = leaf, x = group)) +
  geom_boxplot()

an %>% ggplot(aes(x = leaf)) +
  geom_histogram() +
  facet_wrap(~group)

whole <- bind_cols(an, data, rep)

colnames(whole) <- c('species', 'seeds', 'N_leaf', 'steam_growth', 'light', 'nitro',
                     'H2O_intake1', 'H2O_intake2', 'H2O_intake3')
whole <- whole %>% mutate(pest = ifelse(
  seed == "cold",
  sample(c("no", "yes"), size = length(seed), replace = TRUE, prob = c(0.6, 0.4)),
  sample(c("yes", "no"), size = length(seed), replace = TRUE, prob = c(0.7, 0.3))
))


write_xlsx(whole, 'whole.xlsx')

