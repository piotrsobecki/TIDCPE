# Tools for Evaluation of Interaction Dynamics of Concurrent Processes with Applications to Analysis of Biomedical Signals


# About

MATLAB Graphical User Interface (GUI), developed in the reported research to assist in quick and simple data analysis, is presented. These software tools can discover the interaction dynamics of time-varying signals, i.e., they can reveal their correlation in phase and amplitude, as well as their non-linear interconnections. 


# Authors

Piotr Sobecki (ptrsbck@gmail.com)

Jan T Białasiewicz (Jan.Bialasiewicz@ucdenver.edu)

Nicholas Gross (nicholas.gross@gatech.edu)


# Help

- To run the wavelet analysis GUI, run the function: src/wavelet_GUI
	
## Accepted input data format:

is a tab separated text file, in following format (example for Physionet):

   Elapsed time	      I	     II	   RESP	    SCG
      (seconds)	   (mV)	   (mV)	   (mV)	   (mV)
          0.000	  0.163	  0.184	  0.525	 -0.183
    

    Values should be floating point numbers, using dot as a decimal point.

- The format corresponds to "Show samples as text" option in Toolbox parameter of physionet

    http://physionet.org/cgi-bin/atm/ATM

- Sample data files are placed in src/data directory

## Toolbox offers following functions

### Scalograms and Coscalogram
	The former are 2D graphical representations of continuous wavelet transform performed separately on each signal, showing time-frequency analysis.
	The latter is a 2D graphical representation of interaction between two processes, a product of the two scalograms. 
		
### 3D Coscalogram
	3D graphical representation of coscalogram in analysed signal time series
	
### Wavelet Correlation and Cross Coherence
	Another technique used to measure the correlation between two signals: Wavelet Local Correlation Coefficient (WLCC) and Cross Wavelet Coherence Function (CWCF).
	The former is a measure of phase correlation of two series in the time-scale (or time-frequency) domain, and the latter is a measure of the amplitude correlation in the time-scale (or time-frequency) domain
	
### Wavelet Coherence
	Wavelet Coherence (WC) gives a localized view of two time series signals, while reducing the noise through a smoothing operation.

	"The continuous wavelet transform (CWT) allows you to analyze the temporal evolution of the frequency content of a given signal or time series.
	The application of the CWT to two time series and the cross examination of the two decompositions can reveal localized similarities in time and scale. 
	Areas in the time-frequency plane where two time series exhibit common power or consistent phase behavior indicate a relationship between the signals.

	For jointly stationary time series, the cross spectrum and associated coherence function based on the Fourier transform are key tools for detecting common behavior in frequency.
	In the general nonstationary case, wavelet-based counterparts can be defined to provide time-localized alternatives."
	http://www.mathworks.com/help/wavelet/examples/wavelet-coherence.html
		
### Wavelet Bicoherence
		Wavelet bicoherence (WB) allows the two time series signals to be analyzed for phase coupling and non-linear interactions.
	
### Cross Correlation / Single
	Cross-correlation of input signals used to obtain a single result of delay between signals.

	The function will look for the best match between signals 
	in given time phase bounds (min delay, max delay)
		
	
### Cross Correlation / Vectorised 
	Cross-correlation of input signals used to obtain a vector of delay values, 
	treating each scale of CWT analysis separately,
	effectively producing separate delay for each scale.

	The function will look for the best match between signals 
	for each scale in given time phase bounds (min delay, max delay)

## Functions are parametrized with following parameters
   
	The data boxes are populated with default values.

	To change the plots, change the desired values within the text boxes, then select the button 
	that corresponds to the desired plot.
		
### Data Settings:

	Data File
		Loaded using Home -> Open Data -> (Select data source)

	Data Columns To Plot
		Comma separated two columns from input source file eg. 2,3

	Sampling Rate
		Sampling rate of the signal in the loaded data file


### Analysis Settings:

	Frequency range
		Bandwidth of the analysis, obtained using parameters from analysis settings. 
		This property is not editable and is calculated based on editable properties: interpolation sampling rate, scales, CMW bandwidth, CMW center frequency

	Interpolation Sampling Rate
		Target sampling rate used by functions to produce visual interpretation of continuous wavelet transform. 
		May be used to smooth out input signal for better quality (by upsampling), or to increase performance (by downsampling)

	Minimum time
		Starting time for analysis

	Maximum time
		Ending time for analysis

	Scales
		Scales used by continuous wavelet transform to scale mother wavelet. 
		Input format corresponds to MATLAB vector definition  (eg. 1:10:400)
		The lower the step between scales, the higher the resolution of analysis.
		Smaller scales correspond to higher frequencies.

	Smothing Value Over Time
		Length of smoothing window in time.
		Positive integer that specifies the length of a moving average filter in time.
		Used in:
			Wavelet Coherence
			Wavelet Bicoherence

	Smoothing Value Over Scales
		Length of smoothing window in scale. 
		Positive integer that specifies the length of a moving average filter in scale.
		Used in:
			Wavelet Coherence
			Wavelet Bicoherence

	CMW Bandwidth
		Bandwith of the complex morlet wavelet (mother wavelet used in analysis).

	CMW Center Frequency
		Center frequency of the complex morlet wavelet (mother wavelet used in analysis).

