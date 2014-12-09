library(Lahman)
data(Teams)

dfTeams = subset(Teams, yearID > 1900)

dfTeams$RunsPerGame = with(dfTeams, R / G)
dfTeams$RunsAllowedPerGame = with(dfTeams, RA / G)
dfTeams = subset(dfTeams, lgID != 'FL')

dfLeague <- aggregate(cbind(R, RA, G, H, AB) ~ yearID + lgID, data = dfTeams, sum)

dfLeague = subset(dfLeague, lgID != 'FL')
dfLeague$RunsPerGame = with(dfLeague, R / G)
dfLeague$RunsAllowedPerGame = with(dfLeague, RA / G)
dfLeague$BattingAverage = with(dfLeague, H / AB)
dfLeague$RunsPerHit = with(dfLeague, R / H)

library(ggplot2)

colors = c(NL = "blue", AL="red")
plt = ggplot(data=dfLeague, aes(x=yearID, y=RunsPerGame, group=lgID, color=lgID)) + geom_line()
plt + scale_color_manual(values=colors) + stat_smooth(method="loess", span=0.25, level=0.01)

plt = ggplot(data=dfLeague, aes(x=yearID, y=BattingAverage, group=lgID, color=lgID)) + geom_line()
plt + scale_color_manual(values=colors) + stat_smooth(method="loess", span=0.25, level=0.01)

plt = ggplot(data=dfLeague, aes(x=yearID, y=RunsPerHit, group=lgID, color=lgID)) + geom_line()
plt + scale_color_manual(values=colors) 

plot(dfLeague$H, dfLeague$R, pch=19)

plt = ggplot(data = dfTeams, aes(x=R, y=W, color=lgID)) + geom_point() + stat_smooth(method="lm")
plt + scale_color_manual(values=colors) 

fitRuns = lm(W ~ R + lgID, data=dfTeams)

dfMojo <- aggregate(cbind(W, R) ~ lgID, data = dfTeams, sum)

dfMojo = cbind(dfTeams[, c("lgID", "W", "R")], predict(fit))
coef = fit$coefficients
dfMojo$Predict2 = with(dfMojo, coef["(Intercept)"] + coef["R"] * R)
dfMojo$Predict2[dfMojo$lgID == "NL"] = dfMojo$Predict2[dfMojo$lgID == "NL"] + coef["lgIDNL"]

fitAttend = lm(W ~ attendance, data=dfTeams)
plt = ggplot(data = dfTeams, aes(x=attendance, y=W)) + geom_point() + stat_smooth(method="lm")
plt
plt + scale_color_manual(values=colors) 

ggplot(data = dfTeams, aes(x=attendance, y=R)) + geom_point()
