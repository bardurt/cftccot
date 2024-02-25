# cftccot
This is a small project that collects the data for Commitment of Traders from <b>cftc.gov</b>
<br />

The Commitment of Traders report is a weekly report that shows the holdings of different participants in the futures market.
<br />
<br />

#### Note
The data collectionn is only for Commercial traders, positions of non-commercial traders are not collected at the moment (might add it in the future)
<br />
<br />

The COT data, for different assets, is stored as csv in the <b>\data</b> folder and follows this format
<table>
<tr>
<td>
  Date (YYMMDD)
</td>
  <td>
  Name
</td>
    <td>
  Commercial Long Positions
</td>
      <td>
  Commercial Short Positions
</td>
</tr>
<tr>
<td>
  240130
</td>
  <td>
  NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE
</td>
    <td>
 156086
</td>
      <td>
  203979
</td>
</tr>
  
</table>
<br/>

## Plotting Data
The file `cot_plot.R` contains a function that reads files from `data` folder and plots the data as a barchart. The plot will be normalized to the input data
ex : if the user selects to plot 3 months, then the plot data will be normalized to use the midpoint (between the high and low for the time period) as the origin point.

#### Notes about COT data
it is not the absolute value of the cot data that is important, it is the relative data (3, 6 or 12 months) that shows the true change in the position of the big players, therefore the data is normalized. 

<img src="https://github.com/bardurt/cftccot/blob/main/sp500_cot_plot.png" width="1024"/>

<img src="https://github.com/bardurt/cftccot/blob/main/sp500_cot_12m_plot.png" width="1024"/>

<img src="https://github.com/bardurt/cftccot/blob/main/sp500_cot_6m_plot.png" width="1024"/>

<img src="https://github.com/bardurt/cftccot/blob/main/sp500_cot_3m_plot.png" width="1024"/>
