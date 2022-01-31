// implementation of WSC based on Bock et al 2019
//
class WisconsinCardSortingTask{
    int default_dim = 3; // color, shape, number
    int default_features = 4;
    int default_templates = default_features;
    int default_winstreak = 3;
    int default_taskswitches = 6;

    int nb_dim;
    int nb_features;
    int nb_templates;

    int time = 0;
    int responsetime = 0;
    float[][][] reference_cards;
    int current_rule;
    int prev_rule;
    int winstreak = 0; // number of correct 
    int task_switches = 0;
    int maxwinstreak = 0;
    int maxtaskswitches = 0;
    int errors = 0;
    int perservations = 0;
    ArrayList<Integer> responsetimes = new ArrayList<Integer>();  


    //constructor
    WisconsinCardSortingTask(int adim, int afeatures, int amaxwinstreak, int amaxtaskswitches){
        nb_dim = adim;
        nb_features = afeatures;
        nb_templates = afeatures;
        maxwinstreak = amaxwinstreak;
        maxtaskswitches = amaxtaskswitches;
        reference_cards = generateReferenceCards(nb_dim, nb_features, nb_templates);
        current_rule = (int)random(nb_features); // set initial rule
    }

    WisconsinCardSortingTask(){
      nb_dim = default_dim;
        nb_features = default_features;
        nb_templates = default_features;
        maxwinstreak = default_winstreak;
        maxtaskswitches = default_taskswitches;
        reference_cards = generateReferenceCards(nb_dim, nb_features, nb_templates);
        current_rule = (int)random(nb_features); // set initial rule
        //WisconsinCardSortingTask(default_dim, default_features, default_winstreak, default_taskswitches);
    }

    // gets
    int getTaskSwitches(){return task_switches;}
    boolean isComplete(){return task_switches == maxtaskswitches;}
    // get a new card to process
    float[][] getNewCard(){
        float[][] retval = zeros(nb_dim, nb_features);
        for (int i = 0; i < nb_dim; ++i) {
            int feat = int(random(nb_features));
            retval[i][feat] = 1.f;
        }
        responsetime = 0;
        return retval;

    }

    // Stats:
    // 
    int[] getStats(){
        int[] retval = new int[4];
        int i = 0;
        retval[i++] = time;
        retval[i++] = errors;
        retval[i++] = perservations;
        return retval;
    }

    // set the answer according to hypothesized rule, and get a reward value (0,1)
    float setAnswer(int ix){
        float retval = 0;
        responsetimes.add(responsetime);
        // responsetime = 0;
        if(ix == current_rule){
            winstreak++;
            retval = 1.f;
            if(winstreak == maxwinstreak){
                prev_rule = current_rule;
                current_rule = switchRule(current_rule, nb_features);
                task_switches++;
                winstreak = 0;
            }
        }
        else{
            errors++;
            // check perservation errors
            if(ix == prev_rule){
                perservations++;
            }

        }
        return retval;
    }



    void tick(){
        time++;
        responsetime++;
    }

    // internals
    float[][][] generateReferenceCards(int adims, int afeatures, int atemplates){
        float[][][] retval = new float[atemplates][adims][afeatures];
        for (int i = 0; i < atemplates; ++i) {
            for (int j = 0; j < adims; ++j) {
                retval[i][j][i] = 1.f;
            }
        }
        return retval; 
    }

    int switchRule(int acurrent_rule, int afeatures){
        int retval = 0;
        do {
            retval = (int)random(afeatures);
        } while(acurrent_rule == retval);

        return retval;
    }
}
