var cht = ( function() {

    function init() {
      chart();
      chart1();
    }

    function chart() {
      var colors = Highcharts.getOptions().colors, 
      categories = ['MSIE', 'Firefox', 'Chrome', 'Safari', 'Opera'], 
      name = 'Browser brands', 
      data = [{
        y : 55.11,
        color : colors[0],
        drilldown : {
          name : 'MSIE versions',
          categories : ['MSIE 6.0', 'MSIE 7.0', 'MSIE 8.0', 'MSIE 9.0'],
          data : [10.85, 7.35, 33.06, 2.81],
          color : colors[0]
        }
      }, {
        y : 21.63,
        color : colors[1],
        drilldown : {
          name : 'Firefox versions',
          categories : ['Firefox 2.0', 'Firefox 3.0', 'Firefox 3.5', 'Firefox 3.6', 'Firefox 4.0'],
          data : [0.20, 0.83, 1.58, 13.12, 5.43],
          color : colors[1]
        }
      }, {
        y : 11.94,
        color : colors[2],
        drilldown : {
          name : 'Chrome versions',
          categories : ['Chrome 5.0', 'Chrome 6.0', 'Chrome 7.0', 'Chrome 8.0', 'Chrome 9.0', 'Chrome 10.0', 'Chrome 11.0', 'Chrome 12.0'],
          data : [0.12, 0.19, 0.12, 0.36, 0.32, 9.91, 0.50, 0.22],
          color : colors[2]
        }
      }, {
        y : 7.15,
        color : colors[3],
        drilldown : {
          name : 'Safari versions',
          categories : ['Safari 5.0', 'Safari 4.0', 'Safari Win 5.0', 'Safari 4.1', 'Safari/Maxthon', 'Safari 3.1', 'Safari 4.1'],
          data : [4.55, 1.42, 0.23, 0.21, 0.20, 0.19, 0.14],
          color : colors[3]
        }
      }, {
        y : 2.14,
        color : colors[4],
        drilldown : {
          name : 'Opera versions',
          categories : ['Opera 9.x', 'Opera 10.x', 'Opera 11.x'],
          data : [0.12, 0.37, 1.65],
          color : colors[4]
        }
      }];

      // Build the data arrays
      var browserData = [];
      var versionsData = [];
      for (var i = 0; i < data.length; i++) {

        // add browser data
        browserData.push({
          name : categories[i],
          y : data[i].y,
          color : data[i].color
        });

        // add version data
        for (var j = 0; j < data[i].drilldown.data.length; j++) {
          var brightness = 0.2 - (j / data[i].drilldown.data.length) / 5;
          versionsData.push({
            name : data[i].drilldown.categories[j],
            y : data[i].drilldown.data[j],
            color : Highcharts.Color(data[i].color).brighten(brightness).get()
          });
        }
      }

      // Create the chart
      chart = new Highcharts.Chart({
        chart : {
          renderTo : 'cht',
          type : 'pie'
        },
        title : {
          text : 'Browser market share, April, 2011'
        },
        yAxis : {
          title : {
            text : 'Total percent market share'
          }
        },
        plotOptions : {
          pie : {
            shadow : false
          }
        },
        tooltip : {
          valueSuffix : '%'
        },
        series : [{
          name : 'Browsers',
          data : browserData,
          size : '60%',
          dataLabels : {
            formatter : function() {
              return this.y > 5 ? this.point.name : null;
            },
            color : 'white',
            distance : -30
          }
        }, {
          name : 'Versions',
          data : versionsData,
          innerSize : '60%',
          dataLabels : {
            formatter : function() {
              // display only if larger than 1
              return this.y > 1 ? '<b>' + this.point.name + ':</b> ' + this.y + '%' : null;
            }
          }
        }]
      });
    }

    function chart1() {
      // Radialize the colors
      Highcharts.getOptions().colors = $.map(Highcharts.getOptions().colors, function(color) {
        return {
          radialGradient : {
            cx : 0.5,
            cy : 0.3,
            r : 0.7
          },
          stops : [[0, color], [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
          ]
        };
      });

      // Build the chart
      chart = new Highcharts.Chart({
        chart : {
          renderTo : 'cht1',
          plotBackgroundColor : null,
          plotBorderWidth : null,
          plotShadow : false
        },
        title : {
          text : 'Browser market shares at a specific website, 2010'
        },
        tooltip : {
          pointFormat : '{series.name}: <b>{point.percentage}%</b>',
          percentageDecimals : 1
        },
        plotOptions : {
          pie : {
            allowPointSelect : true,
            cursor : 'pointer',
            dataLabels : {
              enabled : true,
              color : '#000000',
              connectorColor : '#000000',
              formatter : function() {
                return '<b>' + this.point.name + '</b>: ' + this.percentage + ' %';
              }
            }
          }
        },
        series : [{
          type : 'pie',
          name : 'Browser share',
          data : [['Firefox', 45.0], ['IE', 26.8], {
            name : 'Chrome',
            y : 12.8,
            sliced : true,
            selected : true
          }, ['Safari', 8.5], ['Opera', 6.2], ['Others', 0.7]]
        }]
      });
    }

    function load() {
      menu.get('/admin/chart/', init);
    }

    return {
      load : load
    };
  }());
