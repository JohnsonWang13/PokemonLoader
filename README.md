# PokemonLoader

### Narrative #1

```
As an online user
I want the app automatically load the newest Pokemon list 
```

### Scenarios

```
Given the user has connectivity
 When the user requests to see the Pokemon list
 Then the app should display the Pokemon list
  And replace the cache with new Pokemon list
```

### Narrative #2

```
As an offline user
I want the app show latest saved version of the Pokemon list
```

### Scenarios

```
Given the user doesn't have connectivity
  And there's a cached version of the Pokemon list
  When the user requests to see the Pokemon list
  Then the app should display the latest Pokemon list saved
  
Given the user doesn't have connectivity
  And the cache is empty
 When the user requests to see the Pokemon list
 Then the app should display an error message 
```

### Narrative #3

```
As an user
I want the Pokemon can be tap and show detail about Pokemon
```

### Scenarios

```
Given there's a Pokemon list
 When the user tap any Pokemon
 Then the app should display Pokemon's detail 
```


## Use cases

### Load types from remote

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Pokemon types" command with above data
2. System download data from URL
3. System validates downloaded data
4. System create Pokemon types

---

### Load Pokemon list from remote

#### Data:
- URL
- offset
- limit

#### Primary course (happy path):
 
1. Execute "Load Pokemon item list" command with above data.
2. System download data from URL with offset and limit
3. System validates downloaded data
4. System create Pokemon list from validate data
5. System download Pokemon data from every Pokemon item list url
6. System validates downloaded Pokemon detail data
7. System create Pokemon detail from validate data
8. System match Pokemon item list and Pokemon detail
9. System delivers Pokemon detail list

#### Invalid data (sad path)

1. System delivers invalid data error

#### No connectivity (sad path)

1. System delivers connectivity error

---
