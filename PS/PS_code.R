#' ---
#' title: "Problem Set Discussions"
#' author: "Albert Y. Kim"
#' date: "Last updated on `r Sys.Date()`"
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     toc_depth: 1
#'     theme: cosmo
#'     highlight: tango
#'     df_print: kable
#' ---
#' 
#' <style>
#' h1{font-weight: bold;}
#' h2{color: #3399ff;}
#' h3{color: #3399ff;}
#' slides > slide.backdrop {background: white;}
#' </style>
#' 
## ----setup, include=FALSE------------------------------------------------
# Ignore this:
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, fig.width=8, fig.height=4.5)
set.seed(76)
library(nycflights13)
library(dplyr)
library(ggplot2)
if(FALSE){
  knitr::purl(input="PS/PS.Rmd", output="PS/PS_code.R", documentation=2)
}

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' <!----------------------------------------------------------------------------->
#' # Problem Set 08
#' 
#' ## Question 1:
#' 
#' You are going to compute via simulation and not via mathematical formulas, the 
#' **probability distribution** of all possible sums of two die rolls: for all 
#' possible sums of rolling two dice (x=2, x=3, ..., x=12), we compute
#' Probability(sum of rolling two dice = x).
#' 
#' 1. Write code that will simulate die rolls and manipulate the output so that
#' you end up with a data frame `probs` with 11 rows and 2 columns:
#'     + `sum`: each value of the possible sum of rolling two dice
#'     + `probability`: the observed probability of each value of `sum`
#' 1. Once you've fully created it, change the `eval=FALSE` to `eval=TRUE` in the 
#' starting line of the code block below to have the plot get generated.
#' 1. Note even though `sum` is a numerical variable, we'll treat it as a 
#' categorical variable by using the `as.factor()` command and using a bar chart. It 
#' looks cleaner this way.
#' 
#' 
#' **Solution**:
#' 
#' Key points to understand:
#' 
#' * We first simulate sums of two die rolls. These are the possible outcomes: 2, 3, 4, ..., 11 or 12.
#' * We then count the number of times each outcome occurred using `n()` and not `sum()`
#' * We convert the counts into to proportion by dividing by the number of simulations we did: 10000
#' 
#' 
## ---- eval=TRUE----------------------------------------------------------
# Write your code to create the data frame probs here:
die <- c(1:6)
two_die_rolls <- do(10000) * resample(die, size=2, replace = TRUE)

probs <- two_die_rolls %>% 
  mutate(sum=V1+V2) %>% 
  group_by(sum) %>% 
  summarise(count=n()) %>% 
  mutate(probability=count/10000)

# Suggested ggplot call. Feel free to change it:
ggplot(probs, aes(x=as.factor(sum), y=probability)) +
  geom_bar(stat="identity") +
  labs(x="Sum", y="Probability of Sum", title="Outcomes of Rolling Two Dice")

#' 
#' 
#' 
#' 
#' ## Question 2:
#' 
#' Problem 3.20 on page 162 of the OpenIntro Textbook on "With and without 
#' replacement". For this question, find all probabilities using R's sampling 
#' capabilities.
#' 
#' 
#' **Solution**:
#' 
#' #### Advanced: a) and b) from text
#' 
#' **Starter Code**: We define a `room` and `stadium`, both half female, but with 
#' populations of size `n=10` and `n=10000`. Let `1` represent a female and `0` 
#' represent a male, so that to count the number of females we need to only `sum()`
#' a series of `0`'s and `1`'s.
#' 
## ------------------------------------------------------------------------
room <- rep(c(1, 0), each=5)
stadium <- rep(c(1, 0), each=5000)

# Sampling with and without replacement from the room
room_sample_with_replace <- do(10000)*resample(room, size=2, replace=TRUE)
room_sample_with_replace %>% 
  mutate(num_female = V1+V2) %>% 
  group_by(num_female) %>% 
  summarise(count=n())

room_sample_without_replace <- do(10000)*resample(room, size=2, replace=FALSE)
room_sample_without_replace %>% 
  mutate(num_female = V1+V2) %>% 
  group_by(num_female) %>% 
  summarise(count=n())

# Sampling with and without replacement from the stadium
stadium_sample_with_replace <- do(10000)*resample(stadium, size=2, replace=TRUE)
stadium_sample_with_replace %>% 
  mutate(num_female = V1+V2) %>% 
  group_by(num_female) %>% 
  summarise(count=n())

stadium_sample_with_replace <- do(10000)*resample(stadium, size=2, replace=FALSE)
stadium_sample_with_replace %>% 
  mutate(num_female = V1+V2) %>% 
  group_by(num_female) %>% 
  summarise(count=n())

#' 
#' Fill in the table with the results from your simulations in the code block below
#' 
#' Sampling Type        | Room   | Stadium
#' -------------------- | -------| -------
#' With replacement     | 0.250  | 0.2485
#' Without replacement  | 0.223  | 0.2501
#' 
#' **Conclusion**:
#' 
#' * The effect of sampling with vs without replacement in the room leads to a difference of 2.7%
#' * The effect of sampling with vs without replacement in the stadium leads to a difference of 0.0016%
#' 
#' 
#' #### Advanced: c) from text
#' 
#' **Moral of the Story**: The larger the population, the less the difference in results between sampling
#' with vs without replacement matter.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' <!----------------------------------------------------------------------------->
#' # Problem Set 07
#' 
#' ## Question: `nycflights13` data
#' 
## ---- echo=TRUE, message=FALSE-------------------------------------------
# Load all pacakges necessary
library(ggplot2)
library(dplyr)
library(knitr)

# Load all data sets in nycflights
library(nycflights13)
data(flights)
data(planes)
data(airlines)
data(weather)
data(airports)

#' 
#' You are a junior analyst in the airline industry, specifically working for 
#' Virgin America. You are tasked with calculating Virgin America's total
#' [available seat miles](https://en.wikipedia.org/wiki/Available_seat_miles) for
#' all flights leaving each of the three New York Metropolitan area airports
#' separately, and comparing these figures with those of ExpressJet Airlines Inc, a
#' close rival to your company. Available seat miles are the fundamental units of 
#' production for a passenger-carrying airline and it is a measure of capacity. You
#' are asked for two deliverables:
#' 
#' 1. Present these results in
#'     + A well-formatted and easy to read table
#'     + A cleanly formatted visualization
#' 1. Give a two sentence executive summary on the comparison in available seat
#' miles between Virgin America and ExpressJet Airlines Inc for the three NYC
#' airports.
#' 
#' Please heed the "tao of data analysis" [tips](https://rudeboybert.github.io/MATH116/notes.html#lec18_-_fri_324:_the_tao_of_data_analysis)
#' before starting.
#' 
#' 
#' ## Deliverable 1: Table
#' 
## ---- cache=TRUE---------------------------------------------------------
# Clean up our workspace: Reduce both the flights and planes data sets to only
# those columns and rows we need.
flights_cleaned <- flights %>%
  filter(carrier == "VX" | carrier == "EV") %>% 
  select(tailnum, carrier, distance, origin)

planes_cleaned <- planes %>%
  select(tailnum, seats)

# Now we join the two by the variable "tailnum". Note, when the variable we are
# joining along has the same name in both datasets, we don't need to do: 
# by = c("tailnum" = "tailnum")
flights_planes_joined <- flights_cleaned %>% 
  left_join(planes_cleaned, by = "tailnum") 

results <- flights_planes_joined %>% 
  # Now we can compute ASM:
  mutate(seat_miles = seats * distance) %>% 
  # Since we want all 6 possible origin X carrier pairs, we group by
  # those variables and THEN summarize
  group_by(origin, carrier) %>% 
  summarise(total_seat_miles = sum(seat_miles)) %>% 
  # While not necessary, I decide to sort in descending order of ASM
  arrange(desc(total_seat_miles))

results

#' 
#' 
#' ## Deliverable 2: Visualization
#' 
#' Now when it comes to plotting, recall me email from Thursday, Oct 27 referencing
#' how to plot a `geom_bar()` when you have an explicit variable you want to map to
#' the `y` aesthetic. You need to tell `geom_bar()` to override its default
#' behavior and use the `y=total_seat_miles` variable by setting
#' `geom_bar(stat="identity")`. See the code for Problem Set 05 Discussion -> Q1.c)
#' -> second plot comparing proportions for another example.
#' 
#' **Note**: We don't forget the axes labels and title!
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(results, aes(x=origin, y=total_seat_miles)) +
  geom_bar(stat="identity") +
  facet_wrap(~carrier) +
  labs(x="NYC Airport", y="Total Available Seat Miles", title="Virgin vs ExpressJet Seat Miles in NYC in 2013")

#' 
#' My executive summary: Overall, we (as in Virgin America) have about the same
#' capacity, but definitely spread out over different airports. We've got JFK
#' covered, but definitely don't have the capacity that ExpressJet does at Newark 
#' and La Guardia. So I suggest we target our marketing so that
#' 
#' * we promote our great number of options to people who tend to fly out of JFK.
#' * we start running ads that bad mouth ExpressJet to people who tend to fly out of Newark.
#' 
#' 
#' ## Advanced
#' 
#' Once you get better at these things, you can write code super consisely. Not
#' required for this class...
#' 
## ---- cache=TRUE---------------------------------------------------------
flights %>% 
  left_join(planes, by = "tailnum") %>% 
  filter(carrier %in% c("VX", "EV")) %>% 
  mutate(seat_miles = seats*distance) %>% 
  group_by(origin, carrier) %>% 
  summarise(total_seat_miles = sum(seat_miles)) %>% 
  arrange(desc(total_seat_miles))

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' <!----------------------------------------------------------------------------->
#' # Problem Set 06
#' 
#' ## Question 1: Drug Use Amongst OkCupid Users
#' 
#' Let's revisit the 60,000 San Francisco OkCupid users in 2012 and consider the 
#' variable `drug` reflecting users' answers to a question on their drug use. Run
#' this code first:
#' 
## ---- echo=TRUE----------------------------------------------------------
library(okcupiddata)
data(profiles)
# Convert as missing values in drugs to an actual category "N/A"
profiles <- profiles %>% 
  mutate(drugs = ifelse(is.na(drugs), "N/A", drugs))

#' 
#' 
#' **a)** Type in a series of commands that will output a table of how many men and
#' women there are in this population.
#' 
#' **Solution:** This population skews male.
#' 
## ---- echo=TRUE----------------------------------------------------------
# Write your code below:
male_vs_female <- profiles %>% 
  group_by(sex) %>% 
  summarise(count=n())
male_vs_female

#' 
#' 
#' **b)** Create a visualization that shows the distribution of the different
#' responses of in variable `drugs`.
#' 
#' **Solution:**
#' 
## ---- echo=TRUE----------------------------------------------------------
ggplot(data=profiles, aes(x=drugs)) +
  geom_bar()

#' 
#' **c)** Create a visualization that shows the same information as in part a), but
#' for men and women separately. Who is more likely to say they never use drugs?
#' Men or women?
#' 
#' **Solution:** We plot the raw counts of drug use split by sex. However, we can't 
#' compare these values directly because the population involves 35,829 males and
#' 24,117 females as we saw above!
#' 
## ---- echo=TRUE----------------------------------------------------------
ggplot(data=profiles, aes(x=drugs)) +
  geom_bar() +
  facet_wrap(~sex)

#' 
#' **Advanced**: So instead we must normalize to proportions. Note this was not 
#' expected of you for this problem set at the time, but we are now in a position 
#' to understand it. Here we `group_by` both `sex` and `drugs`, get counts, and 
#' compute proportions, we change the `group_by()` structure, and then instead of
#' summarizing, we mutate to compute a proportion. Ask yourself, what values sum to
#' 1?
#' 
## ---- echo=TRUE----------------------------------------------------------
proportions <- profiles %>% 
  group_by(sex, drugs) %>% 
  summarise(count = n()) %>% 
  group_by(sex) %>% 
  mutate(proportion = count/sum(count)) %>% 
  mutate(proportion = round(proportion, 2))
proportions

#' 
#' Now let's try to plot it. Recall when we covered barplots, we saw there are two cases of barplots:
#' 
#' 1. Where the counts are not pre-computed. what we've been using
#' 1. Where the counts are pre-computed. This case.
#' 
#' We map the `proportion` to the `y` aesthetic. But for this to work, we need to
#' add a note to `geom_bar()` that we are specifying a `y` aesthetic by setting
#' `geom_bar(stat="identity")`
#' 
## ---- echo=TRUE----------------------------------------------------------
ggplot(data=proportions, aes(x=drugs, y=proportion)) +
  geom_bar(stat="identity") +
  facet_wrap(~sex)

#' 
#' We now see that it is women who are more likely to self report that they never
#' use drugs.
#' 
#' **d)** After we loaded the data above via `data(profiles)`, we made sure to
#' convert all missing values, encoded in R as `NA`, to a specific response `N/A`
#' i.e. not answered. Why do you think it was important to do so?
#' 
#' **Solution:** Given the nature of the variable, some people might not be willing
#' to answer. It is important not to ignore these people or we might **bias** the
#' results.
#' 
#' 
#' 
#' ## Question 2: Gapminder
#' 
#' We're going revisit the Gapminder data from PS-05. Run this code first:
#' 
## ------------------------------------------------------------------------
library(gapminder)
data(gapminder)

#' 
#' 
#' **a)** Output a table that shows the mean and median GDP of all countries in the
#' year 2007, but split by continent. Your table should be 5 rows and 3 columns.
#' 
#' 
## ------------------------------------------------------------------------
mean_median_GDP_by_continent <- gapminder %>% 
  filter(year==2007) %>% 
  select(continent, gdpPercap) %>%
  group_by(continent) %>% 
  summarise(
    mean_GDP_per_capita = mean(gdpPercap),
    median_GDP_per_capita = median(gdpPercap)
  )
mean_median_GDP_by_continent

#' 
#' 
#' 
#' ## Question 3: Titanic
#' 
#' Let's study data relating to who survived the Titanic disaster. Run this code
#' first:
#' 
## ---- echo=TRUE----------------------------------------------------------
data(Titanic)
# Convert the Titanic data to data frame format
Titanic <- Titanic %>% 
  tbl_df()

#' 
#' 
#' **a)** Output tables that compares survivor counts
#' 
#' 1. between men and women
#' 1. betweent the different classes
#' 
#' 
#' **Solution:** Let's first look at the `Titanic` data
#' 
## ---- echo=TRUE----------------------------------------------------------
Titanic

#' 
#' We see that the variable `n` reports the **pre-computed** count of passengers
#' for each `Class`, `Sex`, `Age`, `Survived` category. The key difficulty of this
#' question was distiguising between using `n()` to count observations vs `sum()`.
#' Here, we need to `sum(n)`:
#' 
## ---- echo=TRUE----------------------------------------------------------
survival_by_sex <- Titanic %>% 
  group_by(Sex, Survived) %>% 
  summarise(n=sum(n))
survival_by_sex

survival_by_class <- Titanic %>% 
  group_by(Class, Survived) %>% 
  summarise(n=sum(n))
survival_by_class

#' 
#' 
#' 
#' **b)** For each comparison above, indicate who was most likely to survive.
#' 
#' * `Survival` by `Sex`: Female survival 344/(344+126) = 73.2%, Male survival 367/(367+1362) = 21.2%. Women were much more likely to survive.
#' * `Survival` by `Class`: 1st class was most likely to survive at 62.5%
#' 
#' **Advanced**: convert to proportions
#' 
## ---- echo=TRUE----------------------------------------------------------
survival_by_class_prop <- Titanic %>% 
  group_by(Class, Survived) %>% 
  summarise(n=sum(n)) %>% 
  group_by(Class) %>% 
  mutate(proportion = n/sum(n)) %>% 
  mutate(proportion = round(proportion, 3))
survival_by_class_prop

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' <!----------------------------------------------------------------------------->
#' # Problem Set 05
#' 
#' Load needed packages:
#' 
## ------------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(fivethirtyeight)
library(Quandl)
library(lubridate)
library(tidyr)

#' 
#' ## Question 1: Bechdel Test
#' 
#' **a)** What is the Bechdel test? Hint: Read the first three paragraphs of the news
#' article linked in the help file for the bechdel data set.
#' 
#' **b)** The following bit of code takes the bechdel data set, limits to movies made 
#' in 1972 or later, and for each year reports the proportion of movies where 
#' binary is equal to PASS. Run this code (such code is the focus of Chapter 5: 
#' Data Wrangling):
#' 
## ---- cache=TRUE---------------------------------------------------------
bechdel_cleaned <- bechdel %>% 
  select(year, binary) %>% 
  filter(year >= 1972) %>% 
  group_by(year) %>% 
  summarize(prop_pass_bechdel=sum(binary=="PASS")/n())

#' 
#' After `View()`'ing the data, create an appropriate plot that shows the time 
#' trend of the proportion of movies that pass the Bechdel test. Write your code
#' here:
#' 
#' **c)** What can you tell someone who asks "What is the state of female
#' representation" in movies?
#' 
#' 
#' ### Discussion
#' 
#' **a)** For any of the data sets in the `fivethirtyeight` package, the help file 
#' lists information. For example: `?bechdel`. The Bechdel test is:
#' 
#' 1. Are there at least two named women in the movie?
#' 1. Do they have a conversation with each other at some point?
#' 1. Does that conversation involve something other than a male character??
#' 
#' **b)** Notice how we computed the propotion using `group_by()`, `summarize()`,
#' and the `n()` summary/many-to-one function. Also note I forgot to erase the
#' solution to this question, so let me make the plot a little fancier:
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(bechdel_cleaned, aes(x=year, y=prop_pass_bechdel)) +
  geom_line() +
  labs(x="Year", y="Proportion Pass Bechdel Test", 
       "Proportion of Movies that Pass Bechdel Test over Time") +
  geom_smooth(se=FALSE)

#' 
#' `geom_smooth()` adds a **smoother** line, `se=FALSE` suppresses the error bars (
#' try `geom_smooth()` by itself where `se` is set to TRUE by default to see
#' difference). This picks out the **signal** from the **noise**.
#' 
#' **c)** Many possible answers here. In my opinion, there has been an increases 
#' since the 1970's in movies that pass Bechdel, but of late things seem to have 
#' leveled off at about 50%.
#' 
#' 
#' 
#' ## Question 2: Cheese and Milk Production 
#' 
#' Run the code below. It will create a data frame food contains cheese and milk
#' production in the United States for every year since 1925. See these links for
#' more info:
#' 
#' * <https://www.quandl.com/data/USDANASS/NASS_CHEESEPRODUCTIONMEASUREDINLB>
#' * <https://www.quandl.com/data/NASS_MILKPRODUCTIONMEASUREDINLB>
#' 
## ---- cache=TRUE---------------------------------------------------------
cheese <- 
  Quandl("USDANASS/NASS_CHEESEPRODUCTIONMEASUREDINLB", start_date="1925-01-01") %>% 
  mutate(type="cheese", date=ymd(Date), value=Value) %>%
  select(type, date, value) 
milk <- 
  Quandl("USDANASS/NASS_MILKPRODUCTIONMEASUREDINLB", start_date="1925-01-01") %>% 
  mutate(type="milk", date=ymd(Date), value=Value) %>%
  select(type, date, value) 
food <- bind_rows(cheese, milk) %>% 
  tbl_df()

#' 
#' **a)** Between cheese and milk, relatively speaking, which agricultural good has 
#' seen the bigger overall increases in production? Write your code below:
#' 
#' 
#' ### Discussion
#' 
#' At first glance, it seems milk made the biggest gains:
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=food, aes(x=date, y=value, col=type)) + 
  geom_line()

#' 
#' But the above plot is of little use since the scale of milk prices is making it
#' difficult to see any differences in the price of cheese. Let's plot them
#' separately.
#' 
## ---- fig.height=3, fig.width=5, cache=TRUE------------------------------
# Write your code below:
ggplot(data=milk, aes(x=date, y=value)) + 
  geom_line()
ggplot(data=cheese, aes(x=date, y=value)) + 
  geom_line()

#' 
#' Both trend up, but which had the biggest relative increases i.e. which had the **highest percent increase**?
#' 
#' $$
#' \text{Percent difference} = \frac{\text{Price in 2015} - \text{Price in 1925}}{\text{Price in 1925}} \times 100 \%
#' $$
#' 
#' 
## ---- eval=FALSE, echo=FALSE---------------------------------------------
## # Ignore this:
## data_frame(
##   food_type=c("milk", "cheese"),
##   price_1925 = c(90699000000, 501096000),
##   price_2014 = c(206046000000, 11450117000 )
## ) %>%
##   mutate(
##     `Absolute Change` = price_2014 - price_1925,
##     `% Change` = round(`Absolute Change`/price_1925 * 100, 2)
##   ) %>%
##   knitr::kable()

#' 
#' |Food Type |  1925|   2014| Absolute Change| % Change|
#' |:---------|-----------:|------------:|---------------:|--------:|
#' |milk      | 90,699,000,000| 206,046,000,000|    115,347,000,000|   127.18%|
#' |cheese    |   501,096,000|  11,450,117,000|     10,949,021,000|  2185.01%|
#' 
#' Cheese wins by a landslide. 2100% increase.
#' 
#' 
#' 
#' ## Question 3: Histogram 
#' 
#' **a)** Recreate the histogram in Question 2 of the midterm using the following data:
#' 
## ---- cache=TRUE---------------------------------------------------------
example <- data_frame(
  x = c(rep(3, 1), rep(4, 4), rep(5, 10), rep(6, 4), rep(7, 1), rep(3:7, each=4)),
  group = c(rep(1, 20), rep(2, 20))
)

#' 
#' ### Solution
#' 
## ---- echo=TRUE, cache=TRUE----------------------------------------------
ggplot(data=example, aes(x=x)) +
  geom_histogram(bins=5) +
  facet_wrap(~group)

#' 
#' We could've also done `geom_histogram(binwidth=1)`
#' 
#' 
#' 
#' ## Question 4: Drinks 
#' 
#' Let's look at the data set drinks from the `fivethirtyeight` package.
#' 
## ------------------------------------------------------------------------
data(drinks)

#' 
#' **a)** Which 3 countries drink the most total alcohol according to this data?
#' 
#' **b)** The following bit of code uses the `gather()` function from the `tidyr`
#' package to convert the data to tidy format and then arranges it by country. Do 
#' Question 3.b) from the midterm using another `geom` besides `boxplot`.
#' 
## ---- cache=TRUE---------------------------------------------------------
drinks_tidy <- drinks %>%
  gather(type, servings, -c(country, total_litres_of_pure_alcohol)) %>%
  arrange(country)

ggplot(data=drinks_tidy, aes(x=type, y=servings)) + 
  geom_boxplot()

#' 
#' **c)** What type of alcoholic beverage is the most consumed on earth?
#' 
#' 
#' ### Discussion
#' 
#' **a)** The easiest way to do this is to use `View(drinks)` and play with the
#' sorting arrows: Belarus, then Lithuania, then Andorra.
#' 
#' **b)** We really want to emphasize the **beer vs spirits vs wine** comparison 
#' of the numerical variable `servings` above all:
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=drinks_tidy, aes(x=servings)) + 
  geom_histogram(binwidth = 50) +
  facet_wrap(~type)

#' 
#' **c)** In my opinion, this question is best answered using the boxplot: Overall
#' beer seems to be the most popular in terms of servings.
#' 
#' 
#' 
#' ## BONUS
#' 
#' In the TED talk [The best stats you've ever
#' seen](https://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen)
#' Hans Rosling (RIP 2017) presents human and international development data. The 
#' data seen in the video is accessible in the gapminder data set within the 
#' gapminder package:
#' 
## ------------------------------------------------------------------------
library(gapminder)
data(gapminder)

#' 
#' The next bit of code
#' 
#' * Filters the data set to only consider observations for two years: 1952 & 2007
#' * Renames the "pop" variable to "population"
#' 
## ---- cache=TRUE---------------------------------------------------------
gapminder <- 
  filter(gapminder, year==1952 | year==2007) %>% 
  rename(population=pop)

#' 
#' **a)** Recreate the scatterplot of "Child Survival (%)" over "GDP per capita ($)"
#' seen at 12:00 in the video, but
#' 
#' * Making a comparison between 1952 and 2007
#' * Displaying "life expectancy" instead of "Child Survival"
#' 
#' Do so by changing the code snippet below:
## ---- eval=FALSE, echo=TRUE----------------------------------------------
## ggplot(data=DATASETNAME, aes(AES1=VAR1, AES2=VAR2, AES3=VAR3, AES4=VAR4)) +
##   geom_point() +
##   facet_wrap(~VAR5) +
##   scale_x_log10() +
##   labs(x="WRITE INFORMATIVE LABEL HERE", y="WRITE INFORMATIVE LABEL HERE", title="WRITE INFORMATIVE TITLE HERE")

#' 
#' **b)** Describe two facts that would be of interest to international development organizations.
#' 
#' 
#' ### Discussion
#' 
#' **a)** 
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=gapminder, aes(x=gdpPercap, y=lifeExp, size=population, col=continent)) +
  geom_point() + 
  facet_wrap(~year) +
  scale_x_log10() + 
  labs(x="GDP per capita ($)", y="Life Expectancy", title="Life Expectancy over GDP per Capita")

#' 
#' **b)** In my opinion
#' 
#' * Overall, there have been gains in both GDP per capita and life expectancy
#' between 1952 and 2007
#' * However, broken down by continent:
#'     + Europe and the Americas have seen modest gains
#'     + Asia has made massive gains
#'     + Unfortunately Africa still lags behind
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' <!----------------------------------------------------------------------------->
#' # Problem Set 03
#' 
#' Load needed packages:
#' 
## ------------------------------------------------------------------------
library(ggplot2)
library(dplyr)

#' 
#' 
#' ## Question 1: Movie Ratings
#' 
#' The `movies` data set in the `ggplot2movies` package has information and
#' ratings on 28,819 movies. This many data points is a bit unwieldy, so let's
#' take a random sample of 1000 of these movies. Furthermore, let's take the
#' variable `Comedy` and convert it to a `yes` vs `no` (binary) categorical
#' variable. Note: you don't need to understand this code for now, we'll see this
#' when we study data manipulation in Chapter 5.
#' 
## ------------------------------------------------------------------------
library(ggplot2movies)
data(movies)
movies <- movies %>%
  sample_n(1000) %>%
  mutate(Comedy=ifelse(Comedy==1, "yes", "no"))

#' 
#' a) You want to know for these 1000 randomly chosen movies: What is the
#' relationship between the year the movie was made and the IMDB rating?
#' Furthermore, I want to distinguish between comedies and non-comedies. In the
#' code block below, write the code that generates a graphic that will answer
#' this for you. Write your code here:
#' 
#' 
#' ### Discussion
#' 
#' a) Comedy is a categorical variable we can split on by assigning a color to
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=movies, aes(x=year, y=rating, color=Comedy)) +
  geom_point()

#' 
#' 
#' b) This is very hard to eye-ball. We can add a **regression line** for Comedies
#' and Non-Comedies using `geom_smooth()`, which is a kind of `geom_line()`. We'll
#' see more and more of this as the semester progresses. Is that small difference
#' **statistically significant**? Hard to tell.
#' 
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=movies, aes(x=year, y=rating, col=Comedy)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE)

#' 
#' 
#' 
#' ## Question 2: Babynames
#' 
#' Considering the `babynames` data set in the `babynames` package again, we will
#' limit consideration to only the name "Casey".
#' 
## ------------------------------------------------------------------------
library(babynames)
data(babynames)
babynames <- babynames %>%
  filter(name=="Casey")

#' 
#' a) I want to know about popularity trends of the name "Casey" as a male name
#' and as a female name over the years. In the code block below, write the code
#' that generates a graphic that will answer this for you. Write your code here:
#' 
#' b) Given this graphic, what can you say about the name "Casey"? Don't merely
#' describe elements on graphic, but make a broader statement. For example, what
#' would you tell a parent who is interested in naming their child "Casey"?
#' 
#' ### Discussion
#' 
#' a) While we could've made separate plots, its easier to view things on the same plot:
#' 
## ---- cache=TRUE---------------------------------------------------------
ggplot(data=babynames, aes(x=year, y=prop, col=sex)) +
  geom_line()

#' 
#' b) This is a **unisex** name, which interestingly peaked in popularity at the same
#' time in the early 1980's. Take a look at this article from
#' [538](http://fivethirtyeight.com/features/there-are-922-unisex-names-in-america-is-yours-one-of-them/)
#' about unisex names.
