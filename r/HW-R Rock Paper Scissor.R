input_actions <- function() {
  is_not_valid <- TRUE
  while (is_not_valid) {
    player_hand <-
      readline("Please Select your action: Rock✊[1] Paper🖐️[2] Scissor✌️[3] Quit🚪[4]: ")

    message("")
    if (player_hand %in% c("1", "2", "3", "4")) {
      is_not_valid <- FALSE
    }
  }
  computer_hand <- sample(1:3, 1)

  return(c(
    player_hand = as.numeric(player_hand),
    computer_hand = as.numeric(computer_hand)
  ))
}


compare_hand <- function(hand, actions) {
  player_hand <- hand[["player_hand"]]
  computer_hand <- hand[["computer_hand"]]

  message("Player play ", actions[player_hand])
  message("Computer play ", actions[computer_hand])

  if (player_hand == computer_hand) {
    message("Oh! It's Tie")
    result <- "tie"
  } else if ((player_hand - computer_hand) %in% c(1, -2)) {
    message("You Win!!")
    result <- "win"
  } else {
    message("Sorry! You Lose")
    result <- "lose"
  }

  return(result)
}

scoring <- function(result, score) {
  score[result] <- score[result] + 1

  return(score)
}

summarize_score <- function(score) {
  n <- ifelse(sum(score) == 0, 1, sum(score))
  percent <- score / n
  score_result <- data.frame(score, percent = round(percent, 2))

  message("Thank you for playing")
  message("Your score:")
  print(score_result)
}

play <- function() {
  # set action
  actions <- c("Rock ✊", "Paper 🖐️", "Scissor ✌️", "Quit 🚪")

  # set zero score
  score <- c(
    win = 0,
    tie = 0,
    lose = 0
  )

  # set play status
  is_playing <- TRUE

  while (is_playing) {
    hand <- input_actions()

    if (hand[[1]] == 4) {
      summarize_score(score)
      is_playing <- FALSE
    } else {
      result <- compare_hand(hand, actions)

      score <- scoring(result, score)
    }
  }
}

main_rps <- function() {
  # Welcome message
  message("Welcome to Rock Paper Scissor the game.\n")

  # main process
  play()
}

main_rps()
