//
// Demand selection task
// Kools et al 2010

class DemandSelectionTask{
    
    float default_perc_hard_deck = 0.9f;
    float default_perc_easy_deck = 0.1f;
    int default_trials = 600;
    int cardvector_size = 12; // 10 numbers, two colors

    float ratio_hard_deck = 0;
    float ratio_easy_deck = 0;
    int trials;
    float[][] stack_hard;
    float[][] stack_easy;
    float[] correct_hard;
    float[] correct_easy;
    int current_card_hard=0;
    int current_card_easy=0;
    int current_stack;
    int current_answer;
    float[][] answers;
    int timer = 0;
    
    DemandSelectionTask(
        int atrials, 
        float ahardratio,
        float aeasyratio){
        
        trials = atrials;
        ratio_easy_deck = aeasyratio;
        ratio_hard_deck = ahardratio;

        stack_hard = generateStack(ahardratio, atrials);
        stack_easy = generateStack(aeasyratio, atrials);
        correct_hard = generateCorrectResponses(stack_hard);
        correct_easy = generateCorrectResponses(stack_easy);
        answers = zeros(atrials, 4); // 0 = stackid; 1 = current card; 2 = answer; 3 = error status

    }

    DemandSelectionTask(){
        trials = default_trials;
        ratio_easy_deck = default_perc_easy_deck;
        ratio_hard_deck = default_perc_hard_deck;

        stack_hard = generateStack(ratio_hard_deck, trials);
        stack_easy = generateStack(ratio_easy_deck, trials);
        correct_hard = generateCorrectResponses(stack_hard);
        correct_easy = generateCorrectResponses(stack_easy);
        answers = zeros(trials, 4); // 0 = stackid; 1 = current card; 2 = answer; 3 = error status
    }

    int[] getStackRemainingCounts(){
        int[] retval = new int[2];
        retval[0] = trials - current_card_easy;
        retval[1] = trials - current_card_hard;
        return retval;
    }
    int getTrials(){return trials;}
    
    float[] getNewCard(int stack){
        float [] retval = zeros(cardvector_size);
        current_stack = stack;
        if (stack==0){ // easy
            if (current_card_easy < trials)
                retval = stack_easy[current_card_easy];
        }
        else {
            if (current_card_hard < trials)
                retval = stack_hard[current_card_hard];
        }
        return retval;
    }

    void setAnswer(float answer){
        answers[current_answer][0] = current_stack;
        answers[current_answer][1] = current_stack == 0 ? current_card_easy : current_card_hard;
        answers[current_answer][2] = answer;
        
        if(current_stack==0){
            answers[current_answer][3] = (answer == correct_easy[current_card_easy] ? 0 : 1) ; // errors
        }
        else {
            answers[current_answer][3] = (answer == correct_hard[current_card_hard] ? 0 : 1) ; // errors
        }
        current_answer++;
        int tmp = current_stack == 0 ? current_card_easy++ : current_card_hard++;
        print("cur card easy = " + current_card_easy + "; hard = " + current_card_hard);
    }

    void tick(){
        timer++;
    }
    

    // internal
    float[][] generateStack(float aratio, int atrials){
        float[][] retval = zeros(atrials, cardvector_size);
        for (int i = 0; i < atrials; ++i) {
            int number = (int)random(cardvector_size-2);
            int col = random(1.0) < aratio ? 0 : 1; // 0 = "< 3"; 1 = "even"; both have 0 = wrong, 1 = correct
            
            retval[i][number] = 1;
            retval[i][col+cardvector_size-2] = 1; // last two bits as colour
            
        }
        return retval;
    }

    float[] generateCorrectResponses(float[][] stack){
        float[] retval = new float[stack.length];
        for (int i = 0; i < retval.length; ++i) {
            // if stack[i][cardvector_size-2] == 1, col = 0 (blue), else col = 1 (purple)
            float col=0; 
            col = stack[i][cardvector_size-1];
            int number = argmax(stack[i], 0, cardvector_size-2);
            if(col == 0) // blue number, check magnitude, less than 5
                retval[i] = (number < 5 ? 1 : 0);
            else
                retval[i] = (number%2 == 0 ? 1: 0);
        }
        return retval;
    }

    float[] calcStats(){
        float[] retval = zeros(2);
        return retval;
    }
}
