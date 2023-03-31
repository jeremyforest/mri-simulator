function mridemo_t2_spin_echo(do_export_gif)

if (nargin < 1), do_export_gif = 0; end

% Define timline
T_sim = 0.2;

my_timeline = timeline(T_sim);


% Define pulse sequence

rfs = {...
    rf('y', 90,  0e-3, 10e-3), ...
    rf('x', 180, 80e-3 - 10e-3, 20e-3)};

acqs = {acq(  150e-3 - 10e-3 - 4e-3 , 20e-3) };

grads = {};

my_pulse_seq = pulse_sequence(rfs, grads, acqs, my_timeline);


% Setup spin system and run the simulation!
t1_list = [inf inf];
t2_list = [0.4 0.15];

m0_list = [1 1];

n_arrow = 7;

b0_fun = @(n) linspace(-1, 1, n)';


% Setup plot functions
l_str = {'Long T2', 'Short T2'};
my_plot_engine = mrisim_plot_engine(l_str);
my_plot_engine.do_export_gif = do_export_gif;

for c = 1:2

    % Set up and init spin system
    my_spin_system = spin_system(...
        m0_list(c), ...
        t1_list(c), ...
        t2_list(c), ...
        b0_fun, ...
        n_arrow);

    % Set the identity of the system to control plotting
    my_spin_system.c_system = c;

    % Setup the simulator
    my_mri_sim = mrisim(...
        my_pulse_seq, ...
        my_spin_system);

    my_mri_sim.do_stop_b0_rotation_during_rf = 1; 

    % Run simulation
    my_mri_sim.simulate(my_plot_engine);

end











        