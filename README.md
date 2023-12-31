# cognito_api

DReAM package for creating amazon cognito resource server.

## Usage

This package requires the following environment variables to be set in your
DReAM project: `TF_VAR_root_url` or `TF_VAR_domain_prefix`.

### Basic

```shell
dream add cognito_api
```

### With custom scopes

Add the following dreamvars configuration:

```yaml
# dreamvars/cognito_api.yaml

scopes:
  - name: read
    description: Read access
  - name: write
    description: Write access
```

Then run `dream add cognito_api` or `dream up` to update the cognito resource
server.

### Generating client package

Add the following dreamvars configuration:

```yaml
# dreamvars/cognito_api.yaml

create_client_package: true
client_package_repository: movies_cognito_api
scopes:
  - name: read
    description: Read movies
  - name: write
    description: Create, update and delete movies
```

Then run `dream add cognito_api` or `dream up`.

### Integration in Express app

- Install `aws-jwt-verify` npm package for validating JWT token

```shell
npm install aws-jwt-verify
```

- Add the following express middlewares for authenticating the request

```typescript
// auth.ts
import {CognitoJwtVerifier} from 'aws-jwt-verify';
import express, {NextFunction, RequestHandler} from 'express';

declare global {
    namespace Express {
        interface Request {
            auth?: {
                sub: string;
                iss: string;
                client_id: string;
                token_use: string;
                exp: number;
                iat: number;
                username: string;
                scope: string;
            }
        }
    }
}

const verifier = CognitoJwtVerifier.create({
    userPoolId: process.env.USER_POOL_ID!,
    tokenUse: "access",
    clientId: process.env.COGNITO_CLIENT_IDS?.split(',') ?? [],
});

export async function verifyJWT(token: string) {
    try {
        return verifier.verify(token);
    } catch (error) {
        console.error(error);
        return null;
    }
}

// Asynchronous Authentication middleware
export const authenticate: RequestHandler = async (req: express.Request, res: express.Response, next: NextFunction) => {
    const authorizationHeader = req.headers["authorization"]

    if (!authorizationHeader) {
        res.status(401).json({message: "Missing authorization header"});
        return;
    }

    const token = authorizationHeader.split(" ")[1]; // Assuming "Bearer <token>" format

    const auth = await verifyJWT(token); // Awaiting the asynchronous function

    if (!auth) {
        res.status(401).json({message: "Unauthorized"});
        return;
    }

    req.auth = auth; // Assign the auth payload to req.auth

    next(); // Continue to the next middleware or route handler
};

// Authorization middleware - checks if the client has the required scopes
export const requireScopes = (...requiredScopes: string[]): express.RequestHandler => {
    return (req: express.Request, res: express.Response, next: NextFunction) => {
        const userScopes = req.auth?.scope.split(' ') || [];

        // Check if all required scopes are present in the user's scopes
        const hasRequiredScopes = requiredScopes.map(
            scopeToHave => `${process.env.COGNITO_RESOURCE_SERVER_IDENTIFIER}/${scopeToHave}`
        ).every(scope => userScopes.includes(scope));

        if (!hasRequiredScopes) {
            res.status(403).json({message: 'Forbidden: insufficient scopes'});
            return;
        }

        next(); // Continue to the next middleware or route handler
    };
};
```

- Use the middlewares in your express app

```typescript
// index.ts
import express, {Request, Response, Application} from 'express';
import {authenticate, requireScopes} from './auth';


const app: Application = express();
const port = process.env.PORT || 4000;

app.use(express.json());
app.use(express.urlencoded({extended: true}));

app.use(authenticate);

app.get('/', requireScopes('read'), (req: Request, res: Response) => {
    res.json({message: 'Welcome to Express & TypeScript Server'});
});

app.listen(port, () => {
    console.log(`Server is Fire at http://localhost:${port}`);
});
```
