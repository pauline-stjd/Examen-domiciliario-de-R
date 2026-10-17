gapminder <- read.csv("data/gapminder.csv")
library(gapminder)
library(dplyr)
library(ggplot2)

# Ejercicio 2 : Análisis econométrico con datos de gapminder

gapminder <- read.csv("~/Library/Mobile Documents/com~apple~CloudDocs/BA5/Laboratorio para el Análisis de Datos Economicos y Financieros /R/TP/gapminder.csv")
View(gapminder)


set.seed(123)

# Parte 1: Ingreso por persona 
# 1)
min(gapminder$year) #desde cuando tenemos datos
max(gapminder$year) #hasta cuando

df_argentina <- gapminder %>%
  filter(country == "Argentina")

ggplot(df_argentina, aes(x = year, y = income_per_person)) +
  geom_line(color = "blue", size = 1) +
  labs(
    title = "Evolución del ingreso por persona en Argentina",
    x = "Año",
    y = "Ingreso por persona en usd (GDP per capita)"
  ) 

max(df_argentina$income_per_person) #ingreso max en los datos
min(df_argentina$income_per_person) 


# 2)
test_data  <- df_argentina %>% filter(year > 2000) # 10 últimos años (2001-2010)
train_data <- df_argentina %>% filter(year <= 2000)  # el resto, de 1960 a 2000

x_train <- train_data$year
y_train <- train_data$income_per_person

x_test  <- test_data$year
y_test  <- test_data$income_per_person

# 3 modelos (Lineal, Grado 2, Grado 10)
fit_lin  <- lm(y_train ~ x_train)
fit_quad <- lm(y_train ~ poly(x_train, 2, raw = TRUE))
fit_high <- lm(y_train ~ poly(x_train, 10, raw = TRUE))

# Predicciones en una grilla 
x_all <- df_argentina$year
grid  <- data.frame(x = seq(min(x_all), max(x_all), length.out = 400))

grid$lin  <- predict(fit_lin,  newdata = data.frame(x_train = grid$x))
grid$quad <- predict(fit_quad, newdata = data.frame(x_train = grid$x))
grid$high <- predict(fit_high, newdata = data.frame(x_train = grid$x))

#Graficamos 
g_overfit <- ggplot() +
  geom_point(aes(x_train, y_train), color = "blue", size = 1.5, alpha = 0.8) +
  geom_point(aes(x_test, y_test),   color = "red",  size = 1.5, alpha = 0.8) +
  geom_line(data = grid, aes(x, lin,  color = "Grado 1"),  linewidth = 0.8) +
  geom_line(data = grid, aes(x, quad, color = "Grado 2"),  linewidth = 0.8) +
  geom_line(data = grid, aes(x, high, color = "Grado 10"), linewidth = 1) +
  scale_color_manual(values = c("Grado 1" = "green", "Grado 2" = "purple", "Grado 10" = "orange")) +
  labs(
    title = "Ajuste de modelos polinómicos y Overfitting",
    subtitle = "Azul = Train, Rojo = Test",
    x = "Año", y = "Ingreso por persona (GDP per capita)", color = "Modelo"
  ) +
  theme_minimal()

print(g_overfit)

#Evaluación del error RMSE en train y test

rmse <- function(obs, pred) sqrt(mean((obs - pred)^2))

rmse_train <- c(
  Lineal = rmse(y_train, fitted(fit_lin)),
  Quad   = rmse(y_train, fitted(fit_quad)),
  Deg10  = rmse(y_train, fitted(fit_high))
)

rmse_test <- c(
  Lineal = rmse(y_test, predict(fit_lin,  newdata = data.frame(x_train = x_test))),
  Quad   = rmse(y_test, predict(fit_quad, newdata = data.frame(x_train = x_test))),
  Deg10  = rmse(y_test, predict(fit_high, newdata = data.frame(x_train = x_test)))
)

cat("\nRMSE en TRAIN:\n"); print(rmse_train)
cat("\nRMSE en TEST:\n");  print(rmse_test)

# 3)

paises <- c("Argentina", "Brasil", "Chile", "Ecuador", "Bolivia")

# Filtrar y ordenar los datos
df_sud <- gapminder %>%
  filter(country %in% paises) %>%
  select(country, year, income_per_person) %>%
  arrange(country, year)

View(df_sud)

# a) matriz de correlaciones entre los ingreso de los 5 paises

# Cambion los datos para tener una columna por país
matriz <- df_sud %>%
  drop_na() %>%
  pivot_wider(
    names_from = country, 
    values_from = income_per_person) %>%
  select(-year)

matriz_cor <- cor(matriz)
matriz_cor

# b)
df_crecimiento <- df_sud %>%
  group_by(country) %>%
  mutate(growth = log(income_per_person) - log(lag(income_per_person))) %>%
  ungroup() %>%
  filter(!is.na(growth)) # Elimina el primer año que queda como NA

# Matriz de correlación
matriz_crecimiento <- df_crecimiento %>%
  select(country, year, growth) %>%
  pivot_wider(
    names_from = country, 
    values_from = growth) %>%
  select(-year) 

matriz_cor_crecimiento <- cor(matriz_crecimiento)
matriz_cor_crecimiento

# Parte 2

#5.Grafico Life expectancy vs life expectancy female 

df_2010 <- gapminder %>% 
  filter(year == 2010)%>%
  #limpio los datos porque hay NAs y datos no numericos ("-")
  mutate(
    life_expectancy = as.numeric(life_expectancy), 
    life_expectancy_female = as.numeric(life_expectancy_female),
    income_per_person = as.numeric(income_per_person),
    child_mortality = as.numeric(child_mortality),
    children_per_woman = as.numeric(children_per_woman)
  ) %>%
  filter(!is.na(life_expectancy), !is.na(life_expectancy_female))

plot(
  df_2010$life_expectancy_female, df_2010$life_expectancy,
  pch = 16, col = "blue",
  main = "Esperanza de vida total vs. femenina (2010)",
  xlab = "Esperanza de vida femenina (años)",
  ylab = "Esperanza de vida total (años)"
)


# 6. Regresión simple y R^2

reg_simple <- lm(life_expectancy ~ life_expectancy_female, data = df_2010)
abline(reg_simple, col = "red", lwd = 2)

sum_simple <- summary(reg_simple)
print(sum_simple)

r2_simple <- sum_simple$r.squared
cat("\nR^2 Regresión Simple:\n"); print(r2_simple)

# 7. Test de hipótesis H0: life_expectancy_female = life_expectancy vs H1: life_expectancy_female > life_expectancy
# paired t-test

diferencia <- df_2010$life_expectancy_female - df_2010$life_expectancy

test_genero <- t.test(
  df_2010$life_expectancy_female, 
  df_2010$life_expectancy, 
  paired = TRUE, 
  alternative = "greater"
)
print(test_genero)

# 8. Regresión múltiple incluyendo ingreso por persona
reg_mult <- lm(life_expectancy ~ life_expectancy_female + log(income_per_person), data = df_2010)
sum_mult <- summary(reg_mult)
print(sum_mult)
cat("\nR^2 Modelo Múltiple:\n"); print(sum_mult$r.squared)

# 9. Modelo lineal con 3 covariables (excluyendo life_expectancy_female)

# Excluyo tambien "life_expectancy_male" para evitar redundancia tautométrica.
# Selecciono variables socioeconómicas y demográficas: 
# 1. log(income_per_person): representa el nivel de desarrollo económico.
# 2. child_mortality: refleja las condiciones del sistema de salud e infraestructura sanitaria.
# 3. children_per_woman: indicador demográfico.

df_3<- df_2010 %>%
  filter(!is.na(income_per_person), !is.na(child_mortality), !is.na(children_per_woman))

reg_3 <- lm(
  life_expectancy ~ log(income_per_person) + child_mortality + children_per_woman, 
  data = df_3
)

sum_3 <- summary(reg_3)
print(sum_3)

cat("\nR^2 Modelo de 3 covariables:\n");print(sum_3$r.squared)





