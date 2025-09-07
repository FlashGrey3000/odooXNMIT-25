# Synergy Sphere
This is our solution for virtual round of OdooXNMIT hackathon

## What is synergy sphere?
SynergySphere is built on a simple idea: teams do their best work when their
tools truly support how they think, communicate, and move forward together. This platform aims
to go beyond traditional project management software by becoming an intelligent backbone for
teams — helping them stay organized, communicate better, manage resources more effectively,
and make informed decisions without friction.  

At its core, SynergySphere is about helping teams operate at their best — continuously
improving, staying aligned, and working smarter every day.

~~ Odoo Team

## How to run it?
1) Clone the repo
```bash
    git clone https://github.com/FlashGrey3000/odooXNMIT-25.git
    cd odooXNMIT-25
```

2) Start the frontend
```bash
    cd frontend
    pnpm i
    pnpm dev
```

3) Start the docker images for database
```bash
    cd db
    docker-compose up
```
This will spin up the Mysql and Redis servers

4) Start the FastAPI backend for DB interactivity
> Note: Make sure to install all the necessary python libraries *sorry, for not providing the req.txt :(*
```bash
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

5) Update the FastAPI endpoints in the frontend
> Sorry again... You would need to manually go and check the page.tsx files in the frontend, becuase we just hardcoded our LAN ip at the time...
Change such
```tsx
    const FastAPIURL = "http://10.117.45.70:8000"
```
to such
```tsx
    const FastAPIURL = `http:${yourLANIP}:8000` // preferable host it locally to just replace it with localhost
```

## Setting up the flutter app
1) Boot up android studio
Just download the `main.dart` file from the repo and load it into your studio. And compile it.  
It should install all the other dependencies and you should be able to try the app in the debug mode.

## Demo Video
We have a demo video available [here](https://drive.google.com/file/d/1HkPhnFSlEN8Elt9YAFbyV8pt_ztdvP4R/view?usp=drivesdk)  

*If it's not available later. Then I have removed it.*

## Team Members
> [HUSSAIN a.k.a SAMBA8695](https://github.com/SAMBA8695)  
> [Q7000](https://github.com/Q7000)  
> [Flashgrey](https://github.com/FlashGrey3000)  
> [K1ngM0nk](https://github.com/L-10-rush)  