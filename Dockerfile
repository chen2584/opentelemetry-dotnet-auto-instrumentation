# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY src/MyApi/MyApi.csproj ./aspnetapp/MyApi.csproj
RUN dotnet restore /source/aspnetapp/MyApi.csproj

# copy everything else and build app
COPY src/MyApi/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0

ENV OTEL_SERVICE_NAME=myapp
ENV OTEL_RESOURCE_ATTRIBUTES=deployment.environment=stagingservice.version=1.0.0
ENV OTEL_DOTNET_AUTO_HOME=/otel

RUN apt-get update && apt-get install -y unzip curl
RUN mkdir /otel
RUN curl -L -o /otel/otel-dotnet-install.sh https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v1.10.0/otel-dotnet-auto-install.sh
RUN chmod +x /otel/otel-dotnet-install.sh

RUN /bin/bash /otel/otel-dotnet-install.sh

RUN chmod +x /otel/instrument.sh

# RUN /bin/bash /otel/instrument.sh

WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["/bin/bash", "-c", "source /otel/instrument.sh && dotnet MyApi.dll"]