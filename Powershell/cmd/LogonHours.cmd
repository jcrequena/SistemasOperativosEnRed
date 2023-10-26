#net user <username> /times:<days,times>
#Replace <username> with the user account you want to set time limits for. You can get a list of users on the computer by typing in net user and pressing Enter.
#Replace <limits> with the days and times the user would be allowed to use the computer. Days are represented as L, M, X, J, V, S, or D. Times are in 24-hour format. So, for example, you could limit usage on Tuesday from 9am to 5pm by entering /times:T,09:00-17:00. Separate multiple time limits with a semicolon, e.g.: /times:M-F,09:00-17:00;Sa-Sun,09:00-15:00

Ejemplos:
net user test /time:all 
net user test /times:S,09:00-17:00
net user test /times:L-V,09:00-17:00;S-D,09:00-15:00
