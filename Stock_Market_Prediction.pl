% Load necessary libraries
:- use_module(library(csv)).

% Load data from CSV file
load_data(Data) :-
    csv_read_file('V_data.csv', Data).

% Visualize the data (plotting not possible in Prolog, so just printing)
visualize_data(Data) :-
    writeln(Data).

% Split data into training and testing datasets
split_data(Data, TrainData, TestData) :-
    length(Data, Len),
    SplitIndex is floor(0.8 * Len),
    length(TrainData, SplitIndex),
    append(TrainData, TestData, Data),
    length(TestData, TestLen),
    TestLen is Len - SplitIndex.

% Define features and target variable
features(['open', 'volume']).
target(['close']).

% Create and train the model
create_and_train_model(Model) :-
    features(Features),
    target(Target),
    load_data(Data),
    split_data(Data, TrainData, _),
    maplist(row_values(Features, Target), TrainData, Rows),
    extract_features_and_target(Rows, X, Y),
    xgb_train(X, Y, Model).

% Extract features and target from rows
extract_features_and_target([], [], []).
extract_features_and_target([[X, Y] | Rows], [X | Xs], [Y | Ys]) :-
    extract_features_and_target(Rows, Xs, Ys).

% Train XGBoost model
xgb_train(X, Y, Model) :-
    xgb_model(X, Y, Model).

% Make predictions on test data
make_predictions(Model, Predictions) :-
    features(Features),
    load_data(Data),
    split_data(Data, _, TestData),
    maplist(row_values(Features, _), TestData, Rows),
    extract_features(Rows, X),
    xgb_predict(Model, X, Predictions).

% Extract features from rows
extract_features([], []).
extract_features([[X, _] | Rows], [X | Xs]) :-
    extract_features(Rows, Xs).

% Predict using XGBoost model
xgb_predict(Model, X, Predictions) :-
    xgb_predict(Model, X, Predictions).

% Show predictions
show_predictions(Predictions) :-
    writeln("Model predictions: "),
    writeln(Predictions).

% Show actual values
show_actual_values(Targets) :-
    writeln("Actual values: "),
    writeln(Targets).

% Show model accuracy (not directly calculated in Prolog, just printing)
show_accuracy(_Model, _TestData) :-
    writeln("Accuracy: Not calculated in Prolog.").

% Plot predictions and close price (plotting not possible in Prolog, so just printing)
plot_predictions_and_close(_Data, _Predictions, _Target) :-
    writeln("Plotting not available in Prolog.").

% Helper predicate to extract values for given features and target
row_values(Features, Target, Row, Values) :-
    maplist(row_value(Row), Features, FeatureValues),
    memberchk(Target, Row, TargetValue),
    append(FeatureValues, [TargetValue], Values).

% Helper predicate to extract value for a given feature
row_value(Row, Feature, Value) :-
    memberchk(Feature, Row, Value).

% Simple member checking predicate
memberchk(Key, Row, Value) :-
    nth1(Index, Row, Key),
    nth1(Index, Row, Value).

% Example usage:
main :-
    create_and_train_model(Model),
    make_predictions(Model, Predictions),
    show_predictions(Predictions),
    show_actual_values(Targets),
    show_accuracy(Model, TestData),
    plot_predictions_and_close(Data, Predictions, Targets).

:- initialization(main, main).
