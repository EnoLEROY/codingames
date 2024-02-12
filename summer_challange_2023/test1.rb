mutant_scores = {"Quicksnail":140,"Meowverine":246,"Magnetoast":157,"Captain Confetti":87,"Backstreet Boy":228}
threshold = 200

new_set_data = [["Quicksnail",140],["Meowverine",246],["Magnetoast",157],["Captain Confetti",87],["Backstreet Boy",228]]



best_mutant = {"test": 0}
new_set_data.each do |mutant_score|
  if best_mutant[best_mutant.keys[0]] < mutant_score[1] && mutant_score[1] < threshold
    best_mutant = {mutant_score[0] => mutant_score[1]}
  end
end


puts best_mutant.keys[0]


