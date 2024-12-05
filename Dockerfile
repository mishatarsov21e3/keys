FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY BlazorApp.sln ./
COPY ./BlazorApp/BlazorApp.csproj ./BlazorApp/

RUN dotnet restore
COPY . ./
RUN dotnet build ./BlazorApp/BlazorApp.csproj -c Release -o /build

FROM build AS publish
RUN dotnet publish ./BlazorApp/BlazorApp.csproj -c Release -o /publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /publish/wwwroot /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf